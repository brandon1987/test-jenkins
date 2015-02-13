class Addclientportaltasks < ActiveRecord::Migration
  def change
    add_column :customers, :is_portal_maintenancetasks, :boolean, default: false	
  end
end
