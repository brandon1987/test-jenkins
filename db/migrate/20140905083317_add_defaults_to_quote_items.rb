class AddDefaultsToQuoteItems < ActiveRecord::Migration
  def change
    change_column_default :quote_items, :code,                "TEXT"
    change_column_default :quote_items, :quantity,            1
    change_column_default :quote_items, :unit_price,          0
    change_column_default :quote_items, :discount_percentage, 0
    change_column_default :quote_items, :net,                 0
    change_column_default :quote_items, :vat_rate,            0
    change_column_default :quote_items, :vat,                 0
    change_column_default :quote_items, :total,               0
  end
end
