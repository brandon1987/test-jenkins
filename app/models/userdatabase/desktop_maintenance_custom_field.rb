class DesktopMaintenanceCustomField < UserDatabaseRecord
  self.table_name = "tblMaintenanceCustomFields"

  alias_attribute :id,           :tblMaintenanceCustomFields_ID
  alias_attribute :name,         :tblMaintenanceCustomFields_Name
  alias_attribute :defaultvalue, :tblMaintenanceCustomFields_DefaultValue
end