class AddClientportalEmailAddress < ActiveRecord::Migration
  def change
    if self.table_exists?("customers")
      add_column :customers, :clientportal_email, :string, limit:255, default: ""
    end
  end
end
