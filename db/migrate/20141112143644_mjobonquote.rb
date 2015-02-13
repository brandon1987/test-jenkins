class Mjobonquote < ActiveRecord::Migration
  def change
    if self.table_exists?("quotes")
  	  add_column :quotes, :xid_mjob, :integer, default: -1
    end
  end
end
