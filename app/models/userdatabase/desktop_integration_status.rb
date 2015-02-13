class DesktopIntegrationStatus < UserDatabaseRecord
  self.table_name = "tblIntegrationStatus"

 	

  alias_attribute :integrationstatus_id,  :tblIntegrationStatus_ID
  alias_attribute :integrationstatus_value, :tblIntegrationStatus_StatusValue
  alias_attribute :integrationstatus_statusname,:tblIntegrationStatus_StatusName
  alias_attribute :integrationstatus_statusdescription, :tblIntegrationStatus_StatusDescription
end