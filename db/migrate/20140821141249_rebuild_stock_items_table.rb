class RebuildStockItemsTable < ActiveRecord::Migration
  def change
    drop_table :stock_items

    create_table :stock_items do |t|
      t.string  :code,              limit: 64
      t.string  :short_description, limit: 64
      t.string  :long_description,  limit: 500
      t.decimal :unit_cost,         precision: 30, scale: 2
      t.string  :unit_type,         limit: 10
    end
  end
end
