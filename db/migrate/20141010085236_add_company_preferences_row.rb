class AddCompanyPreferencesRow < ActiveRecord::Migration
  def change
  	CompanyPreferences.create :sage_payroll_connection => false if CompanyPreferences.count==0
  end
end
