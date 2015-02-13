class AddBranchIdToQuote < ActiveRecord::Migration
  def change
    if self.table_exists?("quotes")
      add_column :quotes, :branch_address_id, :integer, default: -1
    end
  end
end
