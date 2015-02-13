class CreateQuoteNotesTable < ActiveRecord::Migration
  def change
    create_table :quote_notes do |t|
      t.integer    :quote_id, :default => -1
      t.text       :note
      t.timestamps
    end
  end
end
