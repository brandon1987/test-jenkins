class AssetRegisterLink < ActiveRecord::Migration
  def change
	  create_table :service_plan_link do |t|
	  t.timestamps
	  t.integer "xid_mjob"
	  t.integer "xid_service_plan"
    end
  end
end
