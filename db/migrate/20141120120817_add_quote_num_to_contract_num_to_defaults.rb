class AddQuoteNumToContractNumToDefaults < ActiveRecord::Migration
  def change
    add_column :company_preferences, :quote_num_to_contract_num, :boolean, default: false
  end
end
