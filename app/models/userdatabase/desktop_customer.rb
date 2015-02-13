class DesktopCustomer < UserDatabaseRecord
  self.table_name = "tblcustomers"

  alias_attribute :id,             :tblCustomer_id
  #alias_attribute :tblCustomer_id, :tblCustomer_ID
  alias_attribute :ref,            :tblCustomer_Ref
  alias_attribute :name,           :tblCustomer_Name
  alias_attribute :contact_name,   :tblCustomer_ContactName
  alias_attribute :vat_reg_no,     :tblCustomer_VatRegNo
  alias_attribute :address_1,      :tblCustomer_Add1
  alias_attribute :address_2,      :tblCustomer_Add2
  alias_attribute :town,           :tblCustomer_Add3
  alias_attribute :region,         :tblCustomer_Add4
  alias_attribute :postcode,       :tblCustomer_Add5
  alias_attribute :tel,            :tblCustomer_tel
  alias_attribute :tel_2,          :tblCustomer_tel2
  alias_attribute :fax,            :tblCustomer_fax
  alias_attribute :email,          :tblCustomer_Email
  alias_attribute :www,            :tblCustomer_WWW
  alias_attribute :default_ncode,  :tblCustomer_DefNomCode
  alias_attribute :account_status, :tblCustomer_AccountStatus
end
