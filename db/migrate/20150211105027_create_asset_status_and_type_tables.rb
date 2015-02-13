class CreateAssetStatusAndTypeTables < ActiveRecord::Migration
  def change
    create_table :asset_status do |t|
    	t.timestamps
    	t.string :status_name, :limit => 30, :default => ""
		t.boolean :hide_on_dropdowns, default:false
    end
	AssetStatus.create :status_name => 'Active', :hide_on_dropdowns=>false    
	AssetStatus.create :status_name => 'Decomissioned', :hide_on_dropdowns=>true  

    create_table :asset_type do |t|
    	t.timestamps
    	t.string :type_name, :limit => 30, :default => ""
    end


  end

  def self.down
	drop_table "asset_status"
	drop_table "asset_type"
  end

end
