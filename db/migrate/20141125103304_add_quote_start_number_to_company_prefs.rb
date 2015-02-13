class AddQuoteStartNumberToCompanyPrefs < ActiveRecord::Migration
  def change
    add_column :company_preferences, :quote_start_number, :integer, default: 1
  end
end
