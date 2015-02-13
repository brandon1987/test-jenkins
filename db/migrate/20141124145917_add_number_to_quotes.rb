class AddNumberToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :number, :integer, default: -1
  end
end
