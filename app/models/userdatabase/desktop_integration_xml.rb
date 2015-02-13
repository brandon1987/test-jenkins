class DesktopIntegrationXML < UserDatabaseRecord
  self.table_name = "tblIntegrationXML"


  alias_attribute :id,  :tblIntegrationXML_ID
  alias_attribute :xml, :tblIntegrationXML_XML
end