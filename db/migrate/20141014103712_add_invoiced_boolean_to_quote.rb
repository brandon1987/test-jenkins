class AddInvoicedBooleanToQuote < ActiveRecord::Migration
  def change
    if self.table_exists?("quotes")
      add_column :quotes, :is_invoiced, :boolean, default: false
    end
  end
end
