class DesktopJobAnalysis < UserDatabaseRecord
  self.table_name = "tblJobAnalysis"

  alias_attribute :id,   :tblJobAnalysis_ID
  alias_attribute :name, :tblJobAnalysis_JobAnalysis
end