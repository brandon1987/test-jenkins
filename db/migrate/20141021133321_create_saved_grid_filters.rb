class CreateSavedGridFilters < ActiveRecord::Migration
  def change
    create_table :saved_grid_filters do |t|
    	t.timestamps
    	t.string :tablename, 		:limit => 30, :default => ""
    	t.string :preset_name, 		:limit => 30, :default => ""
    	t.string :column_title, 	:limit => 50, :default => ""
    	t.string :filter_setting, 	:limit => 30, :default => ""
    end
  end
end
