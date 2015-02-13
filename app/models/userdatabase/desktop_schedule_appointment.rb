class DesktopScheduleAppointment < UserDatabaseRecord
  self.table_name = "tblmaintenancescheduleappointments"

  belongs_to :desktop_maintenance_visit, :foreign_key => :tblMaintenanceScheduleAppointments_XIDMaintenanceRelated
  belongs_to :desktop_maintenance_task, :foreign_key => :tblMaintenanceScheduleAppointments_XIDMJob

  alias_attribute :id,                      :tblMaintenanceScheduleAppointments_ID
  alias_attribute :long_description,        :tblMaintenanceScheduleAppointments_LongDescription
  alias_attribute :xid_mjob,                :tblMaintenanceScheduleAppointments_XIDMJob
  alias_attribute :xid_maintenance_related, :tblMaintenanceScheduleAppointments_XIDMaintenanceRelated
  alias_attribute :xid_contract,            :tblMaintenanceScheduleAppointments_XIDContract
  alias_attribute :xid_site_address,        :tblMaintenanceScheduleAppointments_XIDSiteAddress
  alias_attribute :start_time,              :tblMaintenanceScheduleAppointments_StartTime
  alias_attribute :end_time,                :tblMaintenanceScheduleAppointments_EndTime
  alias_attribute :resource_key,            :tblMaintenanceScheduleAppointments_ResourceKey
  alias_attribute :created_by,              :tblmaintenancescheduleappointments_CreatedBy
  alias_attribute :last_updated_by,         :tblmaintenancescheduleappointments_LastUpdated
  alias_attribute :xid_plant,               :tblmaintenancescheduleappointments_XIDPlant
end