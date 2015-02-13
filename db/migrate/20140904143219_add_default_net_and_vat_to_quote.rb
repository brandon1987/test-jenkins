class AddDefaultNetAndVatToQuote < ActiveRecord::Migration
  def change
    change_column_default :quotes, :net, 0
    change_column_default :quotes, :vat, 0
  end
end
