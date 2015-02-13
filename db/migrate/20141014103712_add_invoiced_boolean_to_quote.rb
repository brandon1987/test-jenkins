class AddInvoicedBooleanToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :is_invoiced, :boolean, default: false
  end
end
