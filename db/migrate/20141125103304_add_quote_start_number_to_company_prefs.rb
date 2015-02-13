class AddQuoteStartNumberToCompanyPrefs < ActiveRecord::Migration
  def change
    if self.table_exists?("company_preferences")
      add_column :company_preferences, :quote_start_number, :integer, default: 1
    end
  end
end
