class MakeProductCodeUnique < ActiveRecord::Migration
  def change
    add_index :stock_items, :code, :unique => true
  end
end
