class DesktopSubbieTemplate < UserDatabaseRecord
  self.table_name = "tblsubbietemplates"

  alias_attribute :id,   :tblSubbieTemplates_ID
  alias_attribute :name, :tblSubbieTemplates_TemplateName
end