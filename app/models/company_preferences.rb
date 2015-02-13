class CompanyPreferences < ActiveRecord::Base
  self.table_name = "company_preferences"

  def CompanyPreferences.update(params)
    CompanyPreferences.first.update(params)
  end

  def CompanyPreferences.default_tender_template
    CompanyPreferences.select(:default_tender_template).first.default_tender_template
  end

  def CompanyPreferences.default_tender_template=(new_value)
    CompanyPreferences.first.update({default_tender_template: new_value})
  end

  def CompanyPreferences.quote_num_to_contract_num
    CompanyPreferences.select(:quote_num_to_contract_num).first.quote_num_to_contract_num
  end

  def CompanyPreferences.quote_num_to_contract_num=(new_value)
    CompanyPreferences.first.update({quote_num_to_contract_num: new_value})
  end

  def CompanyPreferences.quote_start_number
    CompanyPreferences.select(:quote_start_number).first.quote_start_number
  end
end