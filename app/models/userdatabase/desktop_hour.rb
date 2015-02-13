class DesktopHour < UserDatabaseRecord
  self.table_name = "tblhours"
  
  alias_attribute :id,                          :tblHoursId
end