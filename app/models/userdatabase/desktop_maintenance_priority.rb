class DesktopMaintenancePriority < UserDatabaseRecord
  self.table_name = "tblpriority"

  alias_attribute :id,               :tblPriority_ID

end