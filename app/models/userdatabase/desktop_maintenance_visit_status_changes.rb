class DesktopMaintenanceVisitStatusChanges < UserDatabaseRecord
  self.table_name = "tblmaintenancecmpdastatuschanges"


  belongs_to :desktop_integration_status, :foreign_key =>:tblMaintenanceCMPDAStatusChanges_IntegrationStatusChangedTo,:primary_key =>  :tblIntegrationStatus_StatusValue




  alias_attribute :id,               :tblMaintenanceCMPDAStatusChanges_ID
  alias_attribute :changedto,        :tblMaintenanceCMPDAStatusChanges_IntegrationStatusChangedTo
  alias_attribute :comment, 		 :tblMaintenanceCMPDAStatusChanges_Comment
  alias_attribute :visitref, 		 :tblmaintenancecmpdastatuschanges_xidvisit
  alias_attribute :timestamp, 		 :tblMaintenanceCMPDAStatusChanges_DateTimeStamp
end


