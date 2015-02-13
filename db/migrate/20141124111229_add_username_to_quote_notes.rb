class AddUsernameToQuoteNotes < ActiveRecord::Migration
  def change
    add_column :quote_notes, :user, :string, default: ""
  end
end
