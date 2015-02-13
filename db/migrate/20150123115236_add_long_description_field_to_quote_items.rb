class AddLongDescriptionFieldToQuoteItems < ActiveRecord::Migration
  def change
    if self.table_exists?("quote_items")
      add_column :quote_items, :long_description, :text, after: :description
    end
  end
end
