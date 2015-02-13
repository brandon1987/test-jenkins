class DesktopTimesheet < UserDatabaseRecord
  self.table_name = "tbltimesheet"
  alias_attribute :id,   :tblTimeSheet_ID
end