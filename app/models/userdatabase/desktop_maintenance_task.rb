class DesktopMaintenanceTask < UserDatabaseRecord

  self.table_name = "tblMaintenanceTask"


  belongs_to :desktop_customer, :foreign_key => :tblMaintenanceTask_XIDCustomerRef,:primary_key => :tblCustomer_Ref
  belongs_to :desktop_contract, :foreign_key => :tblMaintenanceTask_XIDContract
  belongs_to :desktop_maintenance_status, :foreign_key => :tblMaintenanceTask_Status
  belongs_to :desktop_maintenance_priority, :foreign_key => :tblMaintenanceTask_XIDPriority
  belongs_to :desktop_site_address, :foreign_key => :tblMaintenanceTask_XIDSiteAddress




  alias_attribute :id,                          :tblMaintenanceTask_ID

  alias_attribute :xid_site_address,            :tblMaintenanceTask_XIDSiteAddress
  alias_attribute :xid_created_from_repetition, :tblMaintenanceTask_XIDCreatedFromRepetition
  alias_attribute :xid_contract,                :tblMaintenanceTask_XIDContract
  alias_attribute :xid_customer_ref,            :tblMaintenanceTask_XIDCustomerRef
  alias_attribute :xid_priority,                :tblMaintenanceTask_XIDPriority
  alias_attribute :status,                      :tblMaintenanceTask_Status
  alias_attribute :xid_project_manager,         :tblMaintenanceTask_XIDProjectManager
  alias_attribute :xid_schedule,                :tblMaintenanceTask_XIDSchedule
  alias_attribute :xid_customer_branch,         :tblMaintenanceTask_XIDCustomerBranch 

  alias_attribute :inception_datetime,          :tblMaintenanceTask_InceptionDateTime
  alias_attribute :begin_datetime,              :tblMaintenanceTask_BeginDateTime
  alias_attribute :completion_datetime,         :tblMaintenanceTask_CompletionDateTime
  alias_attribute :datetimestamp,               :tblMaintenanceTask_DateTimeStamp
  alias_attribute :planned_completion_datetime, :tblMaintenanceTask_PlannedCompletion
  alias_attribute :ref_1,                       :tblMaintenanceTask_Ref1  
  alias_attribute :ref_2,                       :tblMaintenanceTask_Ref2
  alias_attribute :ref_3,                       :tblMaintenanceTask_Ref3
  alias_attribute :long_description,            :tblMaintenanceTask_LongDescription
  alias_attribute :work_description,            :tblMaintenanceTask_WorkDescription
  alias_attribute :order_value,                 :tblMaintenanceTask_OrderValue
  alias_attribute :manager_name,                :tblMaintenanceTask_ManagerName
  alias_attribute :schedule_name,               :tblMaintenanceTask_ScheduleName
  alias_attribute :username,                    :tblMaintenanceTask_UserName
  alias_attribute :work_carried_out,            :tblMaintenanceTask_WorkCarriedOut

  alias_attribute :is_quote,                    :tblMaintenanceTask_IsQuote
  alias_attribute :is_schedule,                 :tblMaintenanceTask_isSchedule
  alias_attribute :is_product_invoice,          :tblMaintenanceTask_isProductInvoice

  alias_attribute :labour_markup,               :tblMaintenanceTask_LabourMarkup
  alias_attribute :material_markup,             :tblMaintenanceTask_MaterialMarkup
  alias_attribute :sub_markup,                  :tblMaintenanceTask_SubMarkup
  alias_attribute :stock_markup,                :tblMaintenanceTask_StockMarkup
  alias_attribute :po_markup,                   :tblMaintenanceTask_POMarkup
  alias_attribute :visit_planned_start,         :tblMaintenanceRelated_VisitPlannedStart
  alias_attribute :visit_planned_end,           :tblMaintenanceRelated_VisitPlannedEnd

# deprectated fields that we may as well fill in in case problems come up
  alias_attribute :progress_percentage,         :tblMaintenanceTask_ProgressPercentage


 
end