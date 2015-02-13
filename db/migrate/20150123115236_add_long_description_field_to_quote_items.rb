class AddLongDescriptionFieldToQuoteItems < ActiveRecord::Migration
  def change
    add_column :quote_items, :long_description, :text, after: :description
  end
end
