class Mjobonquote < ActiveRecord::Migration
  def change
  	    add_column :quotes, :xid_mjob, :integer, default: -1
  end
end
