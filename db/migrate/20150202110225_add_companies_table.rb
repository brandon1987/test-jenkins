class AddCompaniesTable < ActiveRecord::Migration
  def change
    create_table "companies", force: true do |t|
      t.string "display_name",              limit: 100
      t.string "login_name",                limit: 10
      t.string "last_schema_update",        limit: 19
      t.binary "connection_string"
      t.string "sage_integration_url"
      t.string "sage_integration_password"
    end
  end
end
