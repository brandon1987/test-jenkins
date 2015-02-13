include InviteHelper
include SettingsHelper
include InviteCodeHelper
include GridData
class SettingsController < ApplicationController
  def index
    @help_link_extension = "settings.html"

    @users     = User.where(:xid_company => session[:company_id]).order("username")
    @invites   = Invite.where(:company_id => session[:company_id]).order("recipient")
    @company   = Company.find(session[:company_id])

    @company_preferences = CompanyPreferences.first

    begin
      @mail_preferences = UserMailPreference.find(session[:user_id])
    rescue StandardError => e
      @mail_preferences = UserMailPreference.new
    end
  end

  def check_db_connection
    begin
      @sql_connection = Mysql2::Client.new(
        :host            => request.POST["hostname"],
        :port            => request.POST["port"],
        :username        => request.POST["username"],
        :password        => request.POST["password"],
        :database        => request.POST["database"],
        :connect_timeout => 10
      )

      render :json => {:success => 0}
    rescue StandardError => e
      render :json => {:error => "Connection failed."}
    end
  end

  def save_db_connection
    conn_string  = "mysql:host=" << request.POST["hostname"]
    conn_string << ";port="      << request.POST['port']
    conn_string << ";dbname="    << request.POST['database']
    conn_string << "|username="  << request.POST['username']
    conn_string << "|password="  << request.POST['password']

    session[:userdb_host] = request.POST["hostname"]
    session[:userdb_port] = request.POST['port']
    session[:userdb_db]   = request.POST['database']
    session[:userdb_user] = request.POST['username']
    session[:userdb_pass] = request.POST['password']

    UserDatabaseRecord.establish_connection(
      :adapter  => "mysql2",
      :host     => request.POST["hostname"],
      :port     => request.POST['port'],
      :username => request.POST['database'],
      :password => request.POST['username'],
      :database => request.POST['password'],
      :strict   => false
    )

    key = Digest::SHA1.hexdigest(session[:company_name])
    query = "connection_string = AES_ENCRYPT('#{conn_string}', '#{key}')"

    Company.where(id: session[:company_id]).update_all(query)

    render :json => {:status => 0}
  end

  def save_sage_connection
    company = Company.find(session[:company_id])
    company.sage_integration_url = params["address"]
    company.sage_integration_password = params["password"]

    render :json => {
      :status => company.save
    }
  end

  def test_sage_connection
    sage_interactor = SageInteractor.new(params[:address], params[:password])

    render :json => {
      :success => sage_interactor.test_connection
    }
  end

  def save_email_templates
    params = post_with_checkboxes

    begin
      UserMailPreference.find(session[:user_id]).update(params)
    rescue StandardError => e
      mail_settings = UserMailPreference.new(params)
      mail_settings.id = session[:user_id]
      mail_settings.save
    end

    render :json => {:status => 0}
  end

  def update_password
    old_pass     = request.POST["old_password"]
    new_pass     = request.POST["new_password"]
    confirm_pass = request.POST["confirm_password"]

    if new_pass != confirm_pass or not password_is_valid?(old_pass)
      render :json => {:status => 1}
    else
      new_salt = BCrypt::Engine.generate_salt
      new_hash = BCrypt::Engine.hash_secret(new_pass, new_salt)

      params = {
        :salt_new => new_salt,
        :hash_new => new_hash
      }

      User.find(session[:user_id]).update(params)

      render :json => {:status => 0}
    end
  end

  def password_is_valid?(pass)
    user = User.find(session[:user_id])
    return user.hash_new == BCrypt::Engine.hash_secret(pass, user.salt_new)
  end

  def revoke_invite
    invite = Invite.find(params[:id])
    if invite.company_id != session[:company_id]
      render :json => {:status => 1}
    else
      invite.destroy
      render :json => {:status => 0}
    end
  end
  def set_clientportal_settings
    customerrecord =Customer.find(params[:customerid])
    if customerrecord

      customerrecord[params[:section]]=params[:settingvalue]
      customerrecord.save
    end
    render :text => "ok"
  end

  def set_clientportal_options
    existingcompanies=Company.select(:id).where("login_name=? AND id!=?", params[:clientportalname],session[:company_id])
    if existingcompanies.count==0
        companyrecord=Company.find(session[:company_id])
        companyrecord.login_name=params[:clientportalname]
        companyrecord.save
        render :text => "ok"        
    else
        render :text => "inuse"
    end
  end

  def send_clientportal_password_email

    customerrecord=Customer.find(params[:customerid])
    customerrecord.clientportal_email=params[:emailaddress]
    customerrecord.save

    invite_code= InviteCodeHelper.invite(params[:emailaddress], session[:company_id],params[:customerid],0,0)
    ArbitraryMailer.client_portal_password(session[:company_id],params[:emailaddress],params[:customerid],invite_code).deliver
    render :text=>"ok"
  end

  def clientportal_customer_gridajaxdata
    #generic grid loading code
    fieldslist=['name','is_portal_maintenance','is_portal_maintenancetasks','id as dummy']
    additionalfields=['clientportal_email']
    strjoins=""
    render :json => getGridData(Customer,params,fieldslist,'id',strjoins,"",nil,additionalfields)
  end

  def converttoclientportalsession
              #set up the spoof connection
              companyid=session[:company_id]
              reset_session
              set_up_clientportal_session(companyid) 

              session[:customer_id] = params[:customerid]

              customer=Customer.find(params[:customerid])
              if customer
                remotecustomer=DesktopCustomer.find(customer.link_id)

                if remotecustomer

                  session[:remotecustomer_id]=remotecustomer.id
                  session[:remotecustomer_ref]=remotecustomer.ref
                  session[:clientportal_access]=[]
                  session[:clientportal_access]<<"maintenance_visits" if customer.is_portal_maintenance
                  session[:clientportal_access]<<"maintenance_tasks" if customer.is_portal_maintenancetasks

                  render :text => "true"

                  return
                else
                  reset_session
                  render :text => "false" #fail out as could not find the remote customer record
                  return
                end
              end

  end

  def save_notification_opt_in
    if params[:setting]=="true"
      UserNotificationOptIns.where(:user_id => session[:user_id], :notification_type=> params[:name]).first_or_create
    else
      UserNotificationOptIns.where(:user_id => session[:user_id], :notification_type=> params[:name]).each do |setting|
        UserNotificationOptIns.destroy(setting.id)
      end
    end
    render :text=>"ok"
  end
  def save_notification_priority
    UserNotificationOptIns.where(:user_id => session[:user_id], :notification_type=> params[:name]).each do |notification|
      notification.update_attribute(:priority, params[:priority])
    end
    render :text=>"ok"
  end  


end