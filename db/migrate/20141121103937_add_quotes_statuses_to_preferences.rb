class AddQuotesStatusesToPreferences < ActiveRecord::Migration
  def change
    add_column :company_preferences, :quote_statuses, :string, default: ""
  end
end
