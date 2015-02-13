class DesktopIntegrationForm < UserDatabaseRecord
  self.table_name = "tblIntegrationForms"

  alias_attribute :xml,   :tblIntegrationForms_XML
end