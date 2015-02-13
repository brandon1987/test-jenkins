class DropQuoteStatusesFieldFromPreferences < ActiveRecord::Migration
  def change
    remove_column :company_preferences, :quote_statuses
  end
end
