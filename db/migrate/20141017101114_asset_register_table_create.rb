class AssetRegisterTableCreate < ActiveRecord::Migration
##        ActiveRecord To Mysql Conversion cheat sheet

##        :primary_key => "int(11) auto_increment PRIMARY KEY",
##        :string      => { :name => "varchar", :limit => 255 },
##        :text        => { :name => "text" },
##        :integer     => { :name => "int", :limit => 4 },
##        :float       => { :name => "float" },
##        :decimal     => { :name => "decimal" },
##        :datetime    => { :name => "datetime" },
##        :time        => { :name => "time" },
##        :date        => { :name => "date" },
##        :binary      => { :name => "blob" },
##        :boolean     => { :name => "tinyint", :limit => 1 }


	def change

		create_table :assets do |asset|
		  asset.timestamps
	      asset.string "name" 								,:limit => 30			, :default =>""
	      asset.string "make" 								,:limit => 30			, :default =>""
	      asset.string "model" 								,:limit => 30			, :default =>""
	      asset.string "serial_no" 							,:limit => 30			, :default =>""
	      asset.integer "xid_site_address" 											, :default =>-1
	      asset.text "locationdescription" 											
	      asset.string "type" 								,:limit => 30			, :default =>""
	      asset.text "notes"											
	      asset.date "installation_date"				
	      asset.date "decomission_date"				
	      asset.string "status"								,:limit => 20			, :default =>""
	  	end 


		create_table :service_plans do |service_plan|
		  service_plan.timestamps
	      service_plan.integer "xid_asset" 											, :default =>""
	      service_plan.date "service_plan_start_date" 								, :default =>"1970-01-01"
	      service_plan.string "service_interval" 			,:limit => 10			, :default =>""
	      service_plan.date "next_service_date" 		
	      service_plan.date "last_service_date" 
	      service_plan.text "service_description" 								
	      service_plan.text "service_requirements"		
	      service_plan.integer "xid_customer" 										, :default =>-1
	      service_plan.integer "xid_contract" 										, :default =>-1
	      service_plan.integer "defaultmjobstatus" 									, :default =>1
	      service_plan.string "xid_maintenance_forms" 		,:limit => 30			, :default =>""
	      service_plan.text "maintenance_form_field_mapping" 			
	      service_plan.decimal "expected_duration" 									, :default=>0.0, precision: 30, scale: 2
	  	end   

	end
end
