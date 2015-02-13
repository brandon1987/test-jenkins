class Customerportalpermission < ActiveRecord::Migration
  def change
    add_column :customers, :client_portal_password, :string, limit: 255, default: ""
    add_column :customers, :is_portal_maintenance, :boolean, default: false
  end
end
