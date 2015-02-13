class UserDatabaseRecord < ActiveRecord::Base
  self.abstract_class = true

  def UserDatabaseRecord.set_details(host, port, username, password, database)
    establish_connection(
      :adapter          => "mysql2",
      :host             => host,
      :port             => port,
      :username         => username,
      :password         => password,
      :database         => database,
      :strict           => false,
      :connect_timeout  => 10,
      :read_timeout     => 10
    )
  end
end