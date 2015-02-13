class AddDefaultTenderTemplateToPreferences < ActiveRecord::Migration
  def change
    add_column :company_preferences, :default_tender_template, :integer, default: -1
  end
end
