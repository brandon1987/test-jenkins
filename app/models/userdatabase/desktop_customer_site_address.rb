# I propose that when we go web only, this model be renamed to BranchAddress
# rather than CustomerSiteAddress, to avoid confusion with the SiteAddress model - james

class DesktopCustomerSiteAddress < UserDatabaseRecord
  self.table_name = "tblBranchAddressesCustomer"

  alias_attribute :id,                    :tblBranchAddressesCustomer_ID
  alias_attribute :xidcustomer,           :tblBranchAddressesCustomer_XIDCustomer
  alias_attribute :add1,                  :tblBranchAddressesCustomer_Add1
  alias_attribute :add2,                  :tblBranchAddressesCustomer_Add2
  alias_attribute :add3,                  :tblBranchAddressesCustomer_Add3
  alias_attribute :add4,                  :tblBranchAddressesCustomer_Add4
  alias_attribute :add5,                  :tblBranchAddressesCustomer_Add5
  alias_attribute :description,           :tblBranchAddressesCustomer_Description
  alias_attribute :tel,                   :tblBranchAddressesCustomer_Tel
  alias_attribute :fax,                   :tblBranchAddressesCustomer_Fax
  alias_attribute :email,                 :tblBranchAddressesCustomer_Email
  alias_attribute :contact,               :tblBranchAddressesCustomer_Contact
  alias_attribute :customerref,           :tblBranchAddressesCustomer_XIDCustomerRef

  def full_address
    [tblBranchAddressesCustomer_Name, tblBranchAddressesCustomer_Add1, tblBranchAddressesCustomer_Add2, tblBranchAddressesCustomer_Add3, tblBranchAddressesCustomer_Add4, tblBranchAddressesCustomer_Add5].reject {|x| x==""}.join(', ').html_safe
  end

  def full_address_returns
    [tblBranchAddressesCustomer_Name, tblBranchAddressesCustomer_Add1, tblBranchAddressesCustomer_Add2, tblBranchAddressesCustomer_Add3, tblBranchAddressesCustomer_Add4, tblBranchAddressesCustomer_Add5].reject {|x| x==""}.join('<br>').html_safe
  end
end
