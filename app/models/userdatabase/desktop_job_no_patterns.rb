class DesktopJobNoPatterns < UserDatabaseRecord
  self.table_name = "tbljobnopatterns"

  alias_attribute :id,          :tblJobNoPatterns_ID  
  alias_attribute :name,        :tblJobNoPatterns_Name
  alias_attribute :pattern,     :tblJobNoPatterns_Pattern
  alias_attribute :jobdefault,  :tblJobNoPatterns_JobDefault
  alias_attribute :taskdefault, :tblJobNoPatterns_TaskDefault
  alias_attribute :startno,     :tblJobNoPatterns_StartNo
end