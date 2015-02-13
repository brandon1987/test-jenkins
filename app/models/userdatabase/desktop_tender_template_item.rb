class DesktopTenderTemplateItem < UserDatabaseRecord
  self.table_name = "tbltenderitems"

  before_create :set_defaults

  alias_attribute :id,          :tblTenderItems_ID
  alias_attribute :template_id, :tblTenderItems_XIDTemplate
  alias_attribute :ref,         :tblTenderItems_Ref
  alias_attribute :amount,      :tblTenderItems_Amount
  alias_attribute :details,     :tblTenderItems_Details
  alias_attribute :is_group,    :tblTenderItems_IsGroup
  alias_attribute :group_id,    :tblTenderItems_XIDGroup

  def set_defaults
    self.template_id ||= -1
    self.ref         ||= ""
    self.amount      ||= 0
    self.details     ||= ""
    self.is_group    ||= 0
    self.group_id    ||= -1
  end

  scope :groups, -> { where(ref: "GROUP") }
end
