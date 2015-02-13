class DesktopMaintenanceVisit < UserDatabaseRecord
  self.table_name = "tblMaintenanceRelated"

  belongs_to :desktop_integration_status, :foreign_key => :tblMaintenanceRelated_IntegrationStatus, :primary_key => :tblIntegrationStatus_StatusValue
  belongs_to :desktop_maintenance_task, :foreign_key => :tblMaintenanceRelated_XIDMJob
  belongs_to :desktop_maintenance_visit_status_changes,:foreign_key => :tblMaintenanceRelated_IntegrationJobNo ,:primary_key => :tblmaintenancecmpdastatuschanges_xidvisit
  belongs_to :desktop_integration_xml, :foreign_key => :tblmaintenancerelated_XIDXML


  has_one :desktop_site_address, through: :desktop_maintenance_task 


  #id/xid
  alias_attribute :id,                                :tblMaintenanceRelated_ID
  alias_attribute :xid_mjob,                          :tblMaintenanceRelated_XIDMJob
  alias_attribute :xid_xml,                           :tblmaintenancerelated_XIDXML  
  alias_attribute :integration_status,                :tblMaintenanceRelated_IntegrationStatus

  #text
  alias_attribute :integration_job_no,                :tblMaintenanceRelated_IntegrationJobNo
  alias_attribute :instructions,                      :tblMaintenanceRelated_Instructions
  alias_attribute :engineer_id,                       :tblMaintenanceRelated_EngineerID
  alias_attribute :name,                              :tblMaintenanceRelated_Name
  alias_attribute :statusname,                        :tblIntegrationStatus_StatusName
  alias_attribute :localstatusname,                   :tblMaintenanceRelated_Status
  alias_attribute :work_carried_out,                  :tblMaintenanceRelated_WorkCarriedOut
  alias_attribute :materials_used,                    :tblMaintenanceRelated_MaterialsUsed
  alias_attribute :resource_key,                      :tblMaintenanceRelated_plannerresourcekey

  #timestamps
  alias_attribute :edit_index,                        :tblMaintenanceRelated_EditIndex
  alias_attribute :visit_planned_start,               :tblMaintenanceRelated_VisitPlannedStart
  alias_attribute :visit_planned_end,                 :tblMaintenanceRelated_VisitPlannedEnd
  alias_attribute :visit_inception,                   :tblMaintenanceRelated_VisitInception
  alias_attribute :transmission_timestamp,            :tblMaintenanceRelated_transmissiontimestamp
  alias_attribute :work_start,                        :tblMaintenanceRelated_WorkStart
  alias_attribute :work_complete,                     :tblMaintenanceRelated_WorkComplete

  #numeric
  alias_attribute :travel_time,                       :tblMaintenanceRelated_TravelTime
  alias_attribute :work_time,                         :tblMaintenanceRelated_WorkTime


  #deprecated fields
  alias_attribute :changes_for_integration,           :tblMaintenanceRelated_ChangesForIntegration
  alias_attribute :integration_error,                 :tblMaintenanceRelated_IntegrationError
  alias_attribute :integration_error_type,            :tblMaintenanceRelated_IntegrationErrorType
  alias_attribute :awaiting_integration_reply,        :tblMaintenanceRelated_AwaitingIntegrationReply
  alias_attribute :work_done,                         :tblMaintenanceRelated_WorkDone
  alias_attribute :special_instructions,              :tblMaintenanceRelated_SpecialInstructions
  alias_attribute :xml_lock,                          :tblMaintenanceRelated_XMLLock

  alias_attribute :engineer_departed,                 :tblMaintenanceRelated_EngineerDeparted
  alias_attribute :engineer_arrived,                  :tblMaintenanceRelated_EngineerArrived
  alias_attribute :visit_completed,                   :tblMaintenanceRelated_VisitCompleted



end