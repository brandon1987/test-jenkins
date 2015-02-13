class DesktopMaintenanceStatus < UserDatabaseRecord
  self.table_name = "tblMaintenanceCustomStatuses"
  alias_attribute :id,               	  :tblMaintenanceCustomStatuses_ID
  alias_attribute :statusname,            :tblMaintenanceCustomStatuses_StatusName
  alias_attribute :default,               :tblMaintenanceCustomStatuses_DefaultStatus
  alias_attribute :defaultoncompletion,   :tblMaintenanceCustomStatuses_DefaultOnCompletion







  belongs_to :desktop_maintenance_visit, :foreign_key => :tblMaintenanceRelated_IntegrationStatus
  belongs_to :desktop_maintenance_status_changes, :foreign_key => :tblMaintenanceStatusChangeLog_STATUS
  
end