include LoginHelper


class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Nicer MySQL timeout handling when there's a problem communicating with the
  # client's data.
  rescue_from ActiveRecord::StatementInvalid,
              Mysql2::Error,
              with: :handle_request_timeout

  rescue_from NoMethodError, :with => :handle_no_method_error

  before_filter do |filter|
    session[:permitted_modules] ||= "{}"
    @permitted_modules = JSON.parse(session[:permitted_modules])

    permitted_endpoints = [
      'login',
      'public',
      'mail',
      'admin/main',
      'admin/companies',
      'admin/users',
      'admin/user_access_rights',
      "clientportal",
      "clientportal/welcome",
      "clientportal/registration",
      "phoneportal",
      "phoneportal/test",
      "phoneportal/main"
    ]

    # Prevent access to most stuff without valid session
    unless permitted_endpoints.include? params[:controller]
      if session[:company_id].nil?
        if params[:controller].include? "clientportal"
          redirect_to "/clientportal/"
        else
          redirect_to "/login"
        end
      end
    end


    unless session[:company_id].nil?
      if connect_as_tenant

        if session[:user_id] == -2
          check_client_portal_bump(permitted_endpoints)
        end
      end
    end

    if session[:access_rights].nil?
      load_access_rights()
    end
    
    if session[:user_id] != -2
      @access_rights=JSON.parse(session[:access_rights]) if !session[:access_rights].nil?
      redirect_to "/permission_denied" if !module_permission_check()
    end

  end



  def connect_as_tenant
    set_tenant_db

    unless params[:controller] == "settings" or params[:action] == "logout"
      if !sage_connection_working?
        redirect_to '/settings#database-settings-tab', :flash => { :error => :no_sage }
        return false
      end
      if !set_remote_db
        redirect_to '/settings#database-settings-tab', :flash => { :error => :no_db }
        return false
      end
    end
    return true
  end

  def set_tenant_db
    Apartment::Tenant.switch("conmag_#{session[:company_id]}")
  end

  def set_remote_db
    if db_should_reconnect?
      begin
        establish_user_db_connection_from_session_data
        return true
      rescue StandardError => e
        return false
      end
    end
    return true
  end

  def db_should_reconnect?
    !(db_host_matches? && db_name_matches? && user_db_connected?)
  end

  def db_host_matches?
    UserDatabaseRecord.connection_config[:host] == session[:userdb_host]
  end

  def db_name_matches?
    UserDatabaseRecord.connection_config[:database] == session[:userdb_db]
  end

  def user_db_connected?
    UserDatabaseRecord.connected?
  end

  def sage_connection_working?
    sage_interactor = SageInteractor.new(
      session[:sage_integration_url],
      session[:sage_integration_password]
    )
    sage_interactor.test_connection
  end

  def handle_request_timeout
    unless request.xhr?
      redirect_to "/de.html" and return
    end
  end

  def handle_no_method_error(errordetail)
    #CORRECT INCORRECT FIELD CASE CORRECTION
    puts "Error Caught: "<<errordetail.to_s

    #CORRECT CUSTOMER ID FIELD CASE
    if errordetail.to_s.start_with?("undefined method `tblCustomer_id'")
      DesktopCustomer.connection.execute("ALTER TABLE tblcustomers CHANGE tblCustomer_id tblCustomer_id INT(11) NOT NULL AUTO_INCREMENT;")
      redirect_from_error and return
    elsif errordetail.to_s.start_with?("undefined method `tblContractId'")
      DesktopContract.connection.execute("ALTER TABLE tblcontracts CHANGE tblContractId tblContractId INT(11) NOT NULL AUTO_INCREMENT;")
      redirect_from_error and return
    else
      #WE DIDN'T RECOGNISE THE ERROR SO WE SHOULD RAISE IT AGAIN FOR THE DEFAULT ERROR HANDLER
      raise
    end
  end

  def redirect_from_error
    unless request.xhr?
      puts "back"
      redirect_to :back
    else
      puts "return false"
      render :json => {
        :status => 0,
        :failed => [],
        :success =>false
      }
    end
  end

  def check_client_portal_bump(permitted_endpoints)
    unless params[:controller].start_with?("clientportal") || params[:controller].start_with?("partial")
      unless permitted_endpoints.include? params[:controller]
        redirect_to "/clientportal/home"
      end
    end
  end

  def load_access_rights()
    if !session[:user_id].nil?
      session[:access_rights] =UserAccessRight.where(user_id: session[:user_id]).first.to_json

    end
  end

  def module_permission_check()
    case params[:controller]
      when "maintenance"

        case params[:action]
          when "show"
            return false if @access_rights["maintenance_edit"]==false
          when "new"
            return false if @access_rights["maintenance_add"]==false
        end

      when "quotes"
        case params[:action]
          when "show"
            return false if @access_rights["quotes_edit"]==false
          when "new"
            return false if @access_rights["quotes_add"]==false
          end
      else
        #some unknown module we don't care about
    end

    return true
  end



end


