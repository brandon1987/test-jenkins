include ProductsHelper
include GridData
include AmazonStorage

class QuotesController < ApplicationController
  def index
    @help_link_extension = "quotes.html"
    @quotes = Quote.order("id DESC").includes(:customer).all

    @reports        = JSON.parse(getAmazonFileList("reports"))
    @default_report = CompanyPreferences.first.default_quote_template
    @default_report ||= ""

    respond_to do |format|
      format.html
      format.xls { @contract_refs = DesktopContract.pluck(:id, :job_no) }
    end
  end

  def gridajaxdata
    @contract_refs    = DesktopContract.pluck(:id, :job_no)
    @maintenance_refs = DesktopMaintenanceTask.pluck(:id, :ref_1)
    site_addresses    = DesktopSiteAddress.pluck(:id, :name)
    analysis_list     = DesktopJobAnalysis.pluck(:id, :name)
    contract_types    = DesktopContractType.pluck(:id, :name)

    project_managers  = DesktopEmployee.project_managers.pluck("tblEmployee_Reference,CONCAT(tblEmployee_FirstName,' ',tblEmployee_Surname) AS managername")
    project_managers += DesktopEmployeeCIS.project_managers.pluck("tblEmployeeCIS_Reference,CONCAT(tblEmployeeCIS_FirstName,' ',tblEmployeeCIS_Surname) AS managername")

    fieldslist = [
      'quotes.number',
      'customers.name',
      'address_id',
      'quotes.date',
      'details',
      'net',
      'vat',
      '(net+vat)',
      'status',
      'xid_contract',
      'xid_mjob',
      'created_events.user AS created_user',
      'date_created',
      'updated_events.user AS updated_user',
      'MAX(updated_events.date) AS date_modified',
      'quotes.ref',
      'quotes.ex_ref',
      'classification_id',
      'analysis_id',
      'project_manager_id'
    ]

    special_filter_indices = [
      fieldslist.index('address_id'),
      fieldslist.index('analysis_id'),
      fieldslist.index('classification_id'),
      fieldslist.index('project_manager_id')
    ]

    special_filters = []

    special_filter_indices.each do |index|
      special_filters[index] = params[:columns]["#{index}"][:search][:value]
      params[:columns]["#{index}"][:search][:value] = ""
    end

    strjoins   = " LEFT JOIN customers ON customers.id=xid_customer "
    strjoins  << " LEFT JOIN audit_events AS created_events ON quotes.id = created_events.related_id AND created_events.event_type='quotes' AND created_events.description='Created' "
    strjoins  << " LEFT JOIN audit_events AS updated_events ON quotes.id = updated_events.related_id AND updated_events.event_type='quotes' AND updated_events.description='Updated' "

    data_fetcher = GridDataFetcher.new
    data_fetcher.model         = Quote
    data_fetcher.grid_params   = params
    data_fetcher.fields_array  = fieldslist
    data_fetcher.str_id_column = "quotes.id"
    data_fetcher.str_joins     = strjoins
    data_fetcher.str_order     = " quotes.id DESC"
    data_fetcher.group         = "quotes.id"
    resultdata = data_fetcher.fetch

    resultdata.data.each do |resultline|
      # Contract link replacement
      index = "#{fieldslist.index('xid_contract')}"
      contract = @contract_refs.find{ |x| x[0] == resultline[index] } if resultline[index]
      if contract
        resultline[index] = "<a href='/contracts/#{resultline[index]}'>#{contract[1]}</a>"
      else
        resultline[index] = ""
      end

      # MJob link replacement
      index = "#{fieldslist.index('xid_mjob')}"
      mjob = @maintenance_refs.find{|x|x[0]==resultline[index]} if resultline[index] != "-1"
      if mjob
        resultline[index]="<a href='/maintenance/#{resultline[index]}'>#{mjob[1]}</a>"
      else
        resultline[index]=""
      end

      # Site address replacement
      index = "#{fieldslist.index('address_id')}"
      site_address = site_addresses.find { |x| x[0] == resultline[index] }[1] if resultline[index] != -1
      if site_address
        resultline[index] = site_address
      else
        resultline[index] = ""
      end

      # Created by replacement
      index = "#{fieldslist.index('created_events.user AS created_user')}"
      resultline[index] = resultline[index].split("@").first if resultline[index]

      # Updated by replacement
      index = "#{fieldslist.index('updated_events.user AS updated_user')}"
      resultline[index] = resultline[index].split("@").first if resultline[index]

      # Classification replacement
      index = "#{fieldslist.index('classification_id')}"
      resultline[index] = perform_replacement(
        resultline,
        index,
        contract_types,
        -1
        )

      # Analysis replacement
      index = "#{fieldslist.index('analysis_id')}"
      resultline[index] = perform_replacement(
        resultline,
        index,
        analysis_list,
        -1
        )

      # Project manager replacement
      index = "#{fieldslist.index('project_manager_id')}"
      resultline[index] = perform_replacement(
        resultline,
        index,
        project_managers,
        -1
        )

      row_id = resultline["DT_RowId"].split("_").last
    end

    resultdata.data.select! do |row|
      valid = true
      special_filters.each_with_index do |filter, index|
        next unless filter
        value = "#{row["#{index}"]}".downcase
        filter.downcase!
        valid = false unless value.include? filter
      end
      valid
    end

    render :json => resultdata
  end

  def perform_replacement(row_data, index, replacements, if_not)
    if row_data[index] && row_data[index] != if_not
      match = replacements.find { |x| x[0] == row_data[index] }
      if match
        new_value = match[1]
      end
    end

    if new_value
      return new_value
    else
      return ""
    end
  end

  def new
    @help_link_extension = "quotes.html"

    @quote = Quote.new
    @quote.date = Time.now
    @quote.number = Quote.next_number

    @products_json = ProductsHelper::product_list.to_json

    begin
      @mail_preferences = UserMailPreference.find(session[:user_id])
    rescue StandardError => e
      @mail_preferences = UserMailPreference.new
    end

    @reports        = JSON.parse(getAmazonFileList("reports"))
    @default_report = CompanyPreferences.first.default_quote_template
    @default_report ||= ""

    @notes = []
    @statuses = QuoteStatus.visible.all
    @branch_addresses = {}
  end

  def create
    items = request.POST
    body = JSON.parse(items["body"])
    items.delete "body"

    @quote = Quote.new(items)

    @quote.date = Time.now unless items["date"]

    @quote.save

    @quote.update_items(body)

    @quote.save

    AuditEvent.new({
      :event_type  => "quotes",
      :user        => session[:username],
      :date        => Time.now,
      :related_id  => @quote.id,
      :description => "Created"
      }).save

    render :text => @quote.id
  end

  def update
    items = request.POST
    items.delete "id"
    body = JSON.parse(items["body"])
    items.delete "body"

    @quote = Quote.find(params[:id])

    @quote.update_items(body)

    @quote.update(items)

    AuditEvent.new({
      :event_type  => "quotes",
      :user        => session[:username],
      :date        => Time.now,
      :related_id  => @quote.id,
      :description => "Updated"
      }).save

    render :json => body
  end

  def show
    @help_link_extension = "quotes.html"

    quote_id = params[:id]

    @quote = Quote.includes(:customer).find(quote_id)

    @quote_items = QuoteItem.all.where(:xid_quote => quote_id)

    @products_json = ProductsHelper::product_list.to_json

    @reports        = JSON.parse(getAmazonFileList("reports"))
    @default_report = CompanyPreferences.first.default_quote_template
    @default_report ||= ""

    begin
      @mail_preferences = UserMailPreference.find(session[:user_id])
    rescue StandardError => e
      @mail_preferences = UserMailPreference.new
    end

    @notes = QuoteNote.where(quote_id: @quote.id).order(created_at: :desc)

    @statuses = QuoteStatus.visible.all

    if @quote.xid_customer == -1
      @branch_addresses = {}
    else
      ref = Customer.find(@quote.xid_customer).ref
      @branch_addresses = DesktopCustomerSiteAddress.where(customerref: ref).select(:id, :add1)
    end
  end

  def destroy
    ids = params[:id].split(",").each do |quote_id|
      Quote.find(quote_id).destroy
      QuoteItem.where(:xid_quote => quote_id).destroy_all
    end

    render :json => {:status => 0}
  end

  def get_printable_quote_list
    @quotes = Quote.order("id DESC").includes(:customer).all
    render "quotes/printable_list", layout: false
  end

  def get_quote_items
    render :json => Quote.find(params[:id]).items
  end

  def attach_to_contract
    contract_id = params[:contract_id]

    @quote = Quote.find(params[:id])
    @quote.attach_to_contract(contract_id)

    AuditEvent.new({
      :event_type  => "quotes",
      :user        => session[:username],
      :date        => Time.now,
      :related_id  => @quote.id,
      :description => "Attached to contract <a href=\"/contracts/#{contract_id}\">##{contract_id}</a>"
    }).save

    if @quote.customer and not @quote.customer.desktop_customer
      @quote.customer.send_to_desktop

      company = Company.find(session[:company_id])

      sage_interactor = SageInteractor.new(
        company.sage_integration_url,
        company.sage_integration_password
      )

      sage_interactor.upsert_customer(@quote.customer.desktop_customer)
    end

    @contract = DesktopContract.find(contract_id)
    unless @contract.customer_ref
      @contract.customer_ref = @quote.customer.desktop_customer.customer_ref
      @contract.save
    end

    render :json => {:status => 0}
  end

  def history
    @events = AuditEvent.where(
      :event_type => "quotes",
      :related_id => params[:id]
    ).order("date DESC")
  end

  def add_note
    @new_note = QuoteNote.new({
      :note     => params[:note],
      :quote_id => params[:quote_id],
      :user     => session[:username]
      })

    render :json => {
      :success   => @new_note.save,
      :timestamp => @new_note.created_at.strftime("%d/%m/%Y at %T"),
      :user      => session[:username]
    }
  end
end
