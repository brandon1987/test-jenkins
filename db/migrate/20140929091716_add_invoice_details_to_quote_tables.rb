class AddInvoiceDetailsToQuoteTables < ActiveRecord::Migration
  def change
    add_column :quotes,      :amount_invoiced,   :decimal, default: 0
    add_column :quote_items, :quantity_invoiced, :integer, default: 0
  end
end
