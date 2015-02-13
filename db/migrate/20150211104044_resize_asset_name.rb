class ResizeAssetName < ActiveRecord::Migration
  def change
  	change_column :assets, :name,:string, :limit => 60
  end
end
