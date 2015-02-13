ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def setup
    set_local_db
  end

  # Add more helper methods to be used by all tests here...
  def login_as(user)
    @request.session[:user_id] = users(user).id
  end

  def login
    @request.session[:company_id]  = 1
    @request.session[:user_id]     = 1
    @request.session[:userdb_host] = Rails.application.secrets[:demo_db_host]
    @request.session[:userdb_port] = Rails.application.secrets[:demo_db_port]
    @request.session[:userdb_user] = Rails.application.secrets[:demo_db_user]
    @request.session[:userdb_pass] = Rails.application.secrets[:demo_db_pass]
    @request.session[:userdb_db]   = "web_test"
    @request.session[:permitted_modules] = "{}"
    @request.session[:priv_level]  = 1
  end

  def set_local_db
    current_host = UserDatabaseRecord.connection_config[:host]
    desired_host = Rails.application.secrets[:demo_db_host]

    current_db = UserDatabaseRecord.connection_config[:database]
    desired_db = "web_test"

    return unless current_host != desired_host || current_db != desired_db || !UserDatabaseRecord.connected?

    UserDatabaseRecord.establish_connection(
      :adapter  => "mysql2",
      :host     => Rails.application.secrets[:demo_db_host],
      :port     => Rails.application.secrets[:demo_db_port],
      :username => Rails.application.secrets[:demo_db_user],
      :password => Rails.application.secrets[:demo_db_pass],
      :database => "web_test",
      :strict   => false
    )

    UserDatabaseRecord.connection.class.class_eval do
      # Unset release savepoint method
      def release_savepoint
      end
    end
  end
end