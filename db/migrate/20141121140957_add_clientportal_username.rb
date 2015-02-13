class AddClientportalUsername < ActiveRecord::Migration
  def change
    add_column :customers, :clientportal_username, :string, limit:50, default: false  	
  end
end
