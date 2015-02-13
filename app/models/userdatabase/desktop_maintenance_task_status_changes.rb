class DesktopMaintenanceTaskStatusChanges < UserDatabaseRecord
  self.table_name = "tblmaintenancestatuschangelog"


  belongs_to :desktop_maintenance_status, :foreign_key =>:tblMaintenanceStatusChangeLog_STATUS,:primary_key =>  :tblMaintenanceCustomStatuses_ID


  alias_attribute :id,               :tblMaintenanceStatusChangeLog_ID
  alias_attribute :xidmjob,          :tblMaintenanceStatusChangeLog_XIDMJOB
  alias_attribute :user, 		 	 :tblMaintenanceStatusChangeLog_USER
  alias_attribute :status, 		 	 :tblMaintenanceStatusChangeLog_STATUS
  alias_attribute :timestamp, 		 :tblMaintenanceStatusChangeLog_TIMESTAMP
end






