class AddCompanyPreferencesTable < ActiveRecord::Migration
  def change
    create_table :company_preferences do |t|
      t.boolean  "sage_payroll_connection", default: false

    end  	
  end
end
