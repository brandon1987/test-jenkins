class DesktopPayGroup < UserDatabaseRecord
  self.table_name = "tblpaygroups"

  alias_attribute :id,               :tblPayGroups_ID
  alias_attribute :name,             :tblPayGroups_GroupName
  alias_attribute :is_cis_pay_group, :tblPayGroups_ISCISPayGroup
end