include CustomersHelper
include GridData

class CustomersController < ApplicationController
  def index
    @customers = Customer.all

    respond_to do |format|
      format.html
      format.json { get_customers_json }
    end
  end

  def new
    @customer = Customer.new
    @branch_addresses = {}
  end

  def show
    @customer = Customer.find(params[:id])

    @branch_addresses = DesktopCustomerSiteAddress.where(customerref: @customer.ref).select(:id, :add1)
  end

  def create
    @customer = Customer.new(request.POST)

    render :json => {
      :success => @customer.save,
      :new_id  => @customer.id
    }
  end

  def update
    customer = Customer.find(params[:id])

    success = customer.update(update_params)

    if success && customer.is_linked
      send_customer_to_sage(customer)
    end

    render :json => {
      :success => success
    }
  end

  def send_customer_to_sage(customer)
    company = Company.find(session[:company_id])

    sage_interactor = SageInteractor.get_by_company_id(session[:company_id])
    sage_interactor.upsert_customer(customer.desktop_customer)
  end

  def destroy
    begin
      Customer.find(params[:id]).destroy
    rescue StandardError => e
      render :json => {:status => 1} and return
    end

    render :json => {:status => 0}
  end

  def get_address
    customer = Customer.find(params[:id])

    render :text => CustomersHelper::formatted_address(customer)
  end

  def import_from_desktop
    failed_imports = []

    current_refs = Customer.pluck(:ref)

    updates = []
    inserts = []

    DesktopCustomer.all.each do |dt_customer|
      params = {
          :link_id      => dt_customer.id,
          :ref          => dt_customer.ref,
          :name         => dt_customer.name,
          :contact_name => dt_customer.contact_name,
          :vat_reg_no   => dt_customer.vat_reg_no,
          :notes        => '',
          :address_1    => dt_customer.address_1,
          :address_2    => dt_customer.address_2,
          :town         => dt_customer.town,
          :region       => dt_customer.region,
          :postcode     => dt_customer.postcode,
          :country_code => 'GB',
          :tel          => dt_customer.tel,
          :tel_2        => dt_customer.tel_2,
          :fax          => dt_customer.fax,
          :email        => dt_customer.email,
          :www          => dt_customer.www
      }

      if current_refs.include? dt_customer.ref
        updates << params
      else
        inserts << "(#{params.map { |k, v| ActiveRecord::Base::sanitize(v) }.join(", ")})"
      end
    end

    query = "INSERT INTO customers ("
    query << "link_id, ref, name, contact_name, vat_reg_no, notes, address_1, address_2, "
    query << "town, region, postcode, country_code, tel, tel_2, fax, email, www"
    query << ") VALUES "
    query << inserts.join(", ")

    ActiveRecord::Base.connection.execute query

    ActiveRecord::Base.transaction do
      updates.each do |update|
        Customer.find_by_ref(update.ref).update(update)
      end
    end

    render :json => {
      :status => 0,
      :failed => failed_imports
    }
  end

  private
  def update_params
    params.permit(
      :link_id, :name, :contact_name, :vat_reg_no, :notes,
      :address_1, :address_2, :town, :region, :postcode, :country_code, :tel,
      :tel_2, :fax, :email, :www, :xid_tax_rate
      )
  end

  def get_customers_json
    fieldslist = ['ref', 'name','contact_name','address_1','postcode','tel','email','www','link_id']
    strjoins = []
    result_data = GridData::get(Customer, params, fieldslist,'id',strjoins,"",nil,[])

    render :json => result_data
  end
end

#
  #  t.integer "link_id"
  #  t.string  "name",                   limit: 50
  #  t.string  "contact_name",           limit: 50
  #  t.string  "vat_reg_no",             limit: 20
  #  t.string  "notes",                  limit: 2000
  #  t.string  "address_1",              limit: 50
  #  t.string  "address_2",              limit: 50
  #  t.string  "town",                   limit: 50
  #  t.string  "region",                 limit: 50
  #  t.string  "postcode",               limit: 50
  #  t.string  "country_code",           limit: 3
  #  t.string  "tel",                    limit: 50
  #  t.string  "tel_2",                  limit: 50
  #  t.string  "fax",                    limit: 50
  #  t.string  "email",                  limit: 50
  #  t.string  "email2",                 limit: 50
  #  t.string  "email3",                 limit: 50
  #  t.string  "www",                    limit: 50
  #  t.integer "xid_tax_rate"
  #  t.string  "client_portal_password",              default: ""
  #  t.boolean "is_portal_maintenance",               default: false
  #  t.string  "clientportal_username",  limit: 50,   default: "0"
  #  t.string  "clientportal_email",                  default: ""