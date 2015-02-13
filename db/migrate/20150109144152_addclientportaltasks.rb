class Addclientportaltasks < ActiveRecord::Migration
  def change
    if self.table_exists?("customers")
      add_column :customers, :is_portal_maintenancetasks, :boolean, default: false
    end
  end
end
