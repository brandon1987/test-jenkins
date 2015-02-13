class DesktopTender < UserDatabaseRecord
  self.table_name = "tblTender"

  before_create :set_defaults

  alias_attribute :id,                :tblTender_ID
  alias_attribute :ref,               :tblTender_Ref
  alias_attribute :details,           :tblTender_Details
  alias_attribute :contract_id,       :tblTender_XIDContract
  alias_attribute :parent_group_id,   :tblTender_XIDParentGroup
  alias_attribute :work_no,           :tblTender_WorkNo
  alias_attribute :cost_budget,       :tblTender_Amount
  alias_attribute :cost_budget_alert, :tblTender_budgetOverspendNotify
  alias_attribute :sales_budget,      :tblTender_SalesBudget
  alias_attribute :tender_type,       :tblTender_TenderType
  alias_attribute :percent_complete,  :tblTender_PercentageComplete
  alias_attribute :value_complete,    :tblTender_ValueComplete
  alias_attribute :authorised,        :tblTender_Authorised
  alias_attribute :works_id,          :tblTender_XIDWorks
  alias_attribute :item,              :tblTender_Item
  alias_attribute :completed,         :tblTender_Completed
  alias_attribute :job_no,            :tblTender_JobNo
  alias_attribute :is_group,          :tblTender_IsGroup
  alias_attribute :level,             :tblTender_Level

  def set_defaults
    self.ref               ||= ""
    self.details           ||= ""
    self.contract_id       ||= -1
    self.parent_group_id   ||= -1
    self.work_no           ||= 0
    self.cost_budget       ||= 0
    self.cost_budget_alert ||= 0
    self.sales_budget      ||= 0
    self.tender_type       ||= 1
    self.percent_complete  ||= 0
    self.value_complete    ||= 0
    self.authorised        ||= -1
    self.works_id          ||= -1
    self.completed         ||= 0
    self.job_no            ||= -1
    self.is_group          ||= 0

    self.tblTender_XID456         ||= -1
    self.tblTender_XIDSupplierRef ||= -1
    self.tblTender_SupplierName   ||= -1
  end

  scope :groups, -> { where(ref: "Group").where(work_no: 0) }
end