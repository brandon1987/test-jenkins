namespace :db do
  desc "Restore the web test database"
  task clean_cm50: :environment do
    db   = Rails.application.secrets[:demo_db]
    host = Rails.application.secrets[:demo_db_host]
    port = Rails.application.secrets[:demo_db_port]
    user = Rails.application.secrets[:demo_db_user]
    pass = Rails.application.secrets[:demo_db_pass]

    file = Rails.root.join("db", "web_test.sql")

    `mysql -u #{user} -p#{pass} -h #{host} #{db} < #{file}`
  end

  desc "Copy tables from the constructionmanager database to the conmag_1 database"
  task copy_db_to_conmag: :environment do
    tables_to_copy = ["assets", "companies", "invites", "password_reset_requests", "permissions", "service_plans", "users"]   
 
    begin
      for table in tables_to_copy
      #check_table = ActiveRecord::Base.connection.execute "SHOW TABLES LIKE 'constructionmanager.#{table}'"
      check_table = ActiveRecord::Base.connection.execute "SELECT *  FROM information_schema.tables WHERE table_schema = 'constructionmanager' AND table_name = '#{table}'";
        if check_table.any?
          ActiveRecord::Base.connection.execute "TRUNCATE TABLE conmag_1.#{table}"
          ActiveRecord::Base.connection.execute "INSERT INTO conmag_1.#{table} SELECT * FROM constructionmanager.#{table}"
        end
      end
    end
  end

end
