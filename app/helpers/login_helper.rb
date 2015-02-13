module LoginHelper
  def set_up_session
    reset_session

    company = Company.find_by(id: @user.xid_company)

    session[:user_id]      = @user.id
    session[:username]     = @user.username
    session[:company_id]   = company.id
    session[:company_name] = company.display_name
    session[:priv_level]   = @user.priv_level
    session[:sage_integration_url] = company.sage_integration_url
    session[:sage_integration_password] = company.sage_integration_password

    set_up_permitted_modules
    ensure_related_records_exist
    load_user_database
  end

  def set_up_permitted_modules
    permitted_modules = Permission.find_by(id_company: session[:company_id])
    session[:permitted_modules] = permitted_modules.to_json
  end

  def set_up_clientportal_session(companyid)
    company = Company.find(companyid)

    session[:user_id]         = -2
    session[:username]        = "clientportal"
    session[:company_id]      = companyid
    session[:company_name]    = company.display_name
    session[:priv_level]      = 3

    load_user_database
  end

  def ensure_related_records_exist
    UserAccessRight.find_or_create_by(:user_id => session[:user_id]).save

    CompanyPreferences.new.save if CompanyPreferences.count == 0
  end

  def load_user_database
    key = Digest::SHA1.hexdigest(session[:company_name])
    query = "AES_DECRYPT(connection_string, '#{key}') AS connection_string"

    conn_details = Company.where(id: session[:company_id]).select(query).first.connection_string

    return if conn_details.nil?

    conn_details = conn_details.split("|")

    host = conn_details[0].split(";")[0].split("=")[1]
    return if host.nil?
    session[:userdb_host] = host

    port = conn_details[0].split(";")[1].split("=")[1]
    port = 3306 if port.nil?
    session[:userdb_port] = port

    database = conn_details[0].split(";")[2].split("=")[1]
    return if database.nil?
    session[:userdb_db] = database

    user = conn_details[1].split("=")[1]
    return if user.nil?
    session[:userdb_user] = user

    pass = conn_details[2].split("=")[1]
    return if pass.nil?
    session[:userdb_pass] = pass

    #establish_user_db_connection_from_session_data
  end

  def establish_user_db_connection_from_session_data
    UserDatabaseRecord.set_details(
      session[:userdb_host],
      session[:userdb_port],
      session[:userdb_user],
      session[:userdb_pass],
      session[:userdb_db]
      )

    UserDatabaseRecord.connection.class.class_eval do
      # Unset release savepoint method
      def release_savepoint
      end
    end
  end
end
