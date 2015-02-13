class AddUsernameToQuoteNotes < ActiveRecord::Migration
  def change
    if self.table_exists?("quote_notes")
      add_column :quote_notes, :user, :string, default: ""
    end
  end
end
