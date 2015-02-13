class CreateClientportalHiddencolumns < ActiveRecord::Migration
  def change
    create_table :clientportal_hiddencolumns do |t|
      t.integer :customer_id, :default => -1    	
      t.string  :section, :limit => 30, :default => ""
      t.string 	:column,:limit=>100,:default=>""
      t.string 	:column_selector,:limit=>100,:default=>""
    end
  end
end

