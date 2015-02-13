class AddClientportalUsername < ActiveRecord::Migration
  def change
    if self.table_exists?("customers")
      add_column :customers, :clientportal_username, :string, limit:50, default: false
    end
  end
end
