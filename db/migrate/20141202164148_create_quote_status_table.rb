class CreateQuoteStatusTable < ActiveRecord::Migration
  def change
    create_table :quote_statuses do |t|
      t.string  :name
      t.boolean :is_default
      t.boolean :is_hidden
    end
  end
end
