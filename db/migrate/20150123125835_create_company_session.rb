class CreateCompanySession < ActiveRecord::Migration
  def change
    create_table :company_sessions do |t|
      t.integer :xid_company, limit:11
      t.integer :xid_user, limit:11
      t.string :session_status, limit: 50, :null => true
      t.datetime :time
      t.string :last_schema_update, limit: 19, :null => true
      t.binary :connection_string
    end
  end
end