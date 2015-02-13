class AddBranchIdToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :branch_address_id, :integer, default: -1
  end
end
