class AddInvoiceDetailsToQuoteTables < ActiveRecord::Migration
  def change
    if self.table_exists?("quotes")
      add_column :quotes,      :amount_invoiced,   :decimal, default: 0
    end

    if self.table_exists?("quote_items")
      add_column :quote_items, :quantity_invoiced, :integer, default: 0
    end
  end
end
