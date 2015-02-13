class AddDefaultQuoteTemplateToCompanyPreferences < ActiveRecord::Migration
  def change
    add_column :company_preferences, :default_quote_template, :string
  end
end
