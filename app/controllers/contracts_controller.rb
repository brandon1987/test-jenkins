include ContractsHelper
include FormatHelper
include AmazonStorage
include GridData

class ContractsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.xls { build_spreadsheet }
    end
  end

  def build_spreadsheet
    @contracts = DesktopContract.select(
      :id, :job_no, :customer_name, :value, :date, :completed_date, :end_date,
      :project_manager)
      .select("tblContractStatus.statusname")
      .select("tblContractTypeName AS type")
      .select("tblJobAnalysis_JobAnalysis AS analysis")
      .select("tbladdresses_Name AS address_name")
      .joins("LEFT JOIN `tblcontractstatus` ON tblcontracts.tblContractStatus = tblcontractstatus.id")
      .joins("LEFT JOIN `tblcontracttype` ON tblcontracts.tblContractType = tblContractTypeID")
      .joins("LEFT JOIN `tbljobanalysis` ON tblcontracts.tblContractXIDJobAnalysis = tblJobAnalysis_ID")
      .joins("LEFT JOIN `tbladdresses` ON tblContractXIDDefaultSA = tblAddresses_ID")
  end

  def gridajaxdata
    fieldslist=['tblContractXidJobNo', "tblContractDescription", 'tblContractXIDCustomer','tbladdresses_Name','tblContractValue','tblContractDate','tblContractCompletedDate','tblContractEndDate','tblContractStatus.statusname','tblContractTypeName','tblJobAnalysis_JobAnalysis','tblContractProjectManager']
    strjoins=" LEFT JOIN `tblcontractstatus` ON tblcontracts.tblContractStatus = tblcontractstatus.id LEFT JOIN `tblcontracttype`   ON tblcontracts.tblContractType = tblContractTypeID LEFT JOIN `tbljobanalysis`    ON tblcontracts.tblContractXIDJobAnalysis = tblJobAnalysis_ID LEFT JOIN `tbladdresses` ON tblContractXIDDefaultSA = tblAddresses_ID "
    resultdata=getGridData(DesktopContract,params,fieldslist,'tblContractId',strjoins,"",nil,[])

    render :json => resultdata
  end

  def new
    set_view_baseline

    @contract                 = DesktopContract.new
    @contract.tblContractDate = Time.now
    @contract.job_no          = DesktopContract.next_job_no
  end

  def create
    DesktopContract.reset_column_information
    ArbitraryMailer.error_email("#{session[:userdb_host]} #{session[:userdb_db]}").deliver

    begin
      @new_contract = DesktopContract.new(contract_params)
    rescue ActionController::ParameterMissing => e
      render :json => {
        :success => false,
        :message => e
      }
      return
    end

    if @new_contract.save
      if params[:quote_ids] != ""
        quote = Quote.find(params[:quote_ids])

        quote.update(
          :xid_contract => @new_contract.id,
          :status       => "Ordered"
          )

        if quote.address_id != -1
          DesktopSiteAddress.find(quote.address_id).attach_to_contract(@new_contract.id)
        end
      end

      render :json => {:success => true, :new_contract => @new_contract.id}
    else
      render :json => {:success => false}
    end
  end

  def new_contract_from_quote
    set_view_baseline

    @quote = Quote.find(params[:id])
    @quote_ids = [params[:id]]

    @contract = DesktopContract.new_from_quote(@quote)

    render "new"
  end

  def show
    set_view_baseline

    @contract = DesktopContract.find(params[:id])

    @quotes   = Quote.where(:xid_contract => @contract.id)
                  .select(:id, :details, :net, :amount_invoiced, :is_invoiced)

    @notes    = DesktopMemo.select(:id, :details)
                  .where(related_id: @contract.id, memo_type: 220).order(id: :desc)

    @site_addresses = DesktopSiteAddress
                      .where(contract_id: @contract.id)
                      .select(:id, :name)

    @eligible_subbies = @contract.get_eligible_subbies

    @related_works = DesktopWork
                      .select(
                        :id, :ref, :number, :contractor_name, :date_started,
                        :details, :retention)
                      .where(contract_id: @contract.id)

    @tender_templates = DesktopTenderTemplate.select(:id, :name)
    @default_tender_template = CompanyPreferences.default_tender_template
  end

  def update
    @contract = DesktopContract.find(params[:id])

    render :json => {
      :success => @contract.update(update_contract_params)
    }
  end

  def add_all_eligible_subbies
    contract = DesktopContract.find(params[:id])
    contract.add_all_eligible_subbies

    render :json => { :success => true }
  end

  def import_site_addresses
    csv_data = params[:file].tempfile

    address_items = []

    csv_data.each_with_index do |csv_line, index|
      next if index == 0 and params[:skip_first] == "1"
      next  if index < params[:from].to_i - 1
      break if index > params[:to].to_i - 1

      line_items = csv_line.split(",")

      columns = params["addresses-columns"].reject { |k, v| v == "-1" }

      column_map = {
        "analysis1"   => :analysis_1,
        "analysis2"   => :analysis_2,
        "analysis3"   => :analysis_3,
        "contact"     => :contact,
        "county"      => :address_5,
        "description" => :description,
        "email"       => :email,
        "fax"         => :fax,
        "name"        => :name,
        "postcode"    => :address_3,
        "ref"         => :ref,
        "street1"     => :address_1,
        "street2"     => :address_2,
        "tel"         => :tel,
        "tel(home)"   => :home_phone,
        "tel(mobile)" => :mobile_phone,
        "tel(work)"   => :work_phone,
        "town"        => :address_4
      }

      address_items = {
        contract_id: params[:id]
      }

      columns.each do |k, v|
        address_items[column_map[k]] = line_items[v.to_i]
      end

      @site_address = DesktopSiteAddress.new(address_items)
      @site_address.save
    end

    render :json => {:success => true}
  end

  def get_site_addresses
    render :json => DesktopSiteAddress
                      .where(contract_id: params[:id])
                      .select(:id, :name)
  end

  def update_defaults
    render :json => {
      :success => DesktopContract.find(params[:id]).update(defaults_params)
    }
  end

  def apply_subbie_template
    refs_to_add = params[:subbie_refs] - DesktopWork.where(contract_id: params[:id]).pluck(:ref)

    subbies = DesktopSupplier.where(ref: refs_to_add).pluck(:ref, :name)

    defaults = DesktopDefault.select(
      :subbie_retention_percentage,
      :subbie_discount_percentage,
      :subbie_retention_period,
      :subbie_retention_and_discount_method
    ).first

    @contract = DesktopContract.where(id: params[:id]).pluck(:description)

    subbies.each do |subbie|
      DesktopWork.new({
        :number              => DesktopWork.next_number_for_contract(params[:id]),
        :ref                 => subbie[0],
        :contract_id         => params[:id],
        :contractor_name     => subbie[1],
        :retention           => defaults.subbie_retention_percentage,
        :ret_period          => defaults.subbie_retention_period,
        :discount_percentage => defaults.subbie_discount_percentage,
        :discount_method     => defaults.subbie_retention_and_discount_method,
        :date_started        => Time.now,
        :details             => @contract[0]
      }).save
    end

    render :json => {
      :success         => true
    }
  end

  def job_no_list
    render :json => DesktopContract.pluck(:job_no)
  end

  private
  def contract_params
    params[:contract_details].permit(
      :job_no, :value, :description, :value_from_tenders, :dayworks, :variations,
      :job_analysis, :project_manager, :special_instructions,
      :customer_ref, :customer_name, :status, :date, :order_no,
      :end_date, :completed_date, :classification
    )
  end

  def update_contract_params
    params[:contract_details].permit(
      :value, :description, :value_from_tenders, :dayworks, :variations,
      :job_analysis, :project_manager, :special_instructions,
      :customer_ref, :customer_name, :status, :date, :order_no,
      :end_date, :completed_date, :classification
    )
  end

  def defaults_params
    [:notify_materials, :notify_products, :notify_sublabour,
      :notify_submaterials, :notify_labour, :notify_purchase
    ].each do |item|
      params[:defaults][item] = params[:defaults][item] == "on" ? 1 : 0
    end

    params[:defaults].permit(
      :retention_percentage, :discount_percentage, :retention_period,
      :retention_and_discount_method, :pay_group, :materials, :notify_materials,
      :products, :notify_products, :sublabour, :notify_sublabour, :submaterials,
      :notify_submaterials, :labour, :notify_labour, :purchase, :notify_purchase
    )
  end
end