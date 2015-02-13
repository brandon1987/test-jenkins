class AddInstructionsToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :instructions, :text
  end
end
