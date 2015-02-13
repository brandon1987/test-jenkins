class AddQuoteNumToContractNumToDefaults < ActiveRecord::Migration
  def change
    if self.table_exists?("company_preferences")
      add_column :company_preferences, :quote_num_to_contract_num, :boolean, default: false
    end
  end
end
