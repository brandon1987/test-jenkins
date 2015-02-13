class AddNumberToQuotes < ActiveRecord::Migration
  def change
    if self.table_exists?("quotes")
      add_column :quotes, :number, :integer, default: -1
    end
  end
end
