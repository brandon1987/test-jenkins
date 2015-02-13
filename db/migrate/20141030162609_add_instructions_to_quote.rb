class AddInstructionsToQuote < ActiveRecord::Migration
  def change
    if self.table_exists?("quotes")
      add_column :quotes, :instructions, :text
    end
  end
end
