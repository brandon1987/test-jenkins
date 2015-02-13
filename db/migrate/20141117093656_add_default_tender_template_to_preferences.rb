class AddDefaultTenderTemplateToPreferences < ActiveRecord::Migration
  def change
    if self.table_exists?("company_preferences")
      add_column :company_preferences, :default_tender_template, :integer, default: -1
    end
  end
end
