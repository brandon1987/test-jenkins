class DesktopSiteAddress < UserDatabaseRecord
  self.table_name  = "tblAddresses"
  self.primary_key = "tblAddresses_ID"

  before_create :defaults

  alias_attribute :id,           :tblAddresses_ID
  alias_attribute :ref,          :tblAddresses_Ref
  alias_attribute :contract_id,  :tblAddresses_XIDContract
  alias_attribute :name,         :tblAddresses_Name
  alias_attribute :address_1,    :tblAddresses_Add1
  alias_attribute :address_2,    :tblAddresses_Add2
  alias_attribute :address_3,    :tblAddresses_Add3
  alias_attribute :address_4,    :tblAddresses_Add4
  alias_attribute :address_5,    :tblAddresses_Add5
  alias_attribute :description,  :tblAddresses_Description
  alias_attribute :tel,          :tblAddresses_Tel
  alias_attribute :fax,          :tblAddresses_Fax
  alias_attribute :email,        :tblAddresses_Email
  alias_attribute :contact,      :tblAddresses_Contact
  alias_attribute :work_phone,   :tblAddresses_WorkPhone
  alias_attribute :home_phone,   :tblAddresses_HomePhone
  alias_attribute :mobile_phone, :tblAddresses_MobilePhone
  alias_attribute :analysis_1,   :tbladdresses_Analysis1
  alias_attribute :analysis_2,   :tbladdresses_Analysis2
  alias_attribute :analysis_3,   :tbladdresses_Analysis3

  def attach_to_contract(contract_id)
    self.contract_id = contract_id
  end

  def full_address
    [name, address_1, address_2, address_3, address_4, address_5
    ].reject { |x| x == "" }.join(', ').html_safe
  end

  def full_address_returns
    [name, address_1, address_2, address_3, address_4, address_5
    ].reject { |x| x == "" }.join('<br>').html_safe
  end

  def defaults
    self.contract_id  ||= -1
    self.name         ||= ""
    self.address_1    ||= ""
    self.address_2    ||= ""
    self.address_3    ||= ""
    self.address_4    ||= ""
    self.address_5    ||= ""
    self.description  ||= ""
    self.tel          ||= ""
    self.fax          ||= ""
    self.email        ||= ""
    self.contact      ||= ""
    self.ref          ||= ""
    self.work_phone   ||= ""
    self.home_phone   ||= ""
    self.mobile_phone ||= ""
    self.analysis_1   ||= ""
    self.analysis_2   ||= ""
    self.analysis_3   ||= ""
  end
end