class DropInvoicedColFromQuotes < ActiveRecord::Migration
  def change
    remove_column :quotes, :invoiced
  end
end
