class DesktopWork < UserDatabaseRecord
  self.table_name = "tblworks"

  before_create :defaults

  alias_attribute :id,                  :tblWorks_Id
  alias_attribute :contract_id,         :tblWorks_XIDContract
  alias_attribute :number,              :tblWorks_Number
  alias_attribute :ref,                 :tblWorks_XID456
  alias_attribute :contractor_name,     :tblWorks_ContractorName
  alias_attribute :date_started,        :tblWorks_StartDate
  alias_attribute :details,             :tblWorks_Description
  alias_attribute :retention,           :tblWorks_Retention
  alias_attribute :ret_period,          :tblWorks_RetPeriod
  alias_attribute :discount_percentage, :tblWorks_Discount
  alias_attribute :discount_method,     :tblWorks_DiscountMethod

  def DesktopWork.next_number_for_contract(contract_id)
    DesktopWork
      .where(contract_id: contract_id)
      .pluck(:number)
      .reject{ |x| x.nil? }
      .max + 1
  end

  def DesktopWork.create_for_contract(contract)
    DesktopWork.reset_column_information
    DesktopWork.new({
      :number          => 0,
      :contract_id     => contract.id,
      :ref             => -1,
      :contractor_name => "",
      :details         => contract.description,
      :retention       => 0
      }).save
  end
end

def defaults
  self.contract_id         ||= -1
  self.number              ||= 0
  self.ref                 ||= ""
  self.contractor_name     ||= ""
  self.details             ||= ""
  self.retention           ||= 0
  self.ret_period          ||= 0
  self.discount_percentage ||= 0
  self.discount_method     ||= 0

  self.tblWorks_Value             ||= 0
  self.tblWorkS_CompletionDate    ||= nil
  self.tblWorks_Completed         ||= 0
  self.tblWorks_RetentionFinal    ||= 0
  self.tblWorks_RetentionPaid     ||= 0
  self.tblWorks_IsDeductLevy      ||= 0
  self.tblWorks_IsCisTax          ||= 0
  self.tblWorks_XidCust           ||= ""
  self.tblWorks_XIDJob            ||= ""
  self.tblWorks_XIDMemo           ||= -1
  self.tblWorks_LastUser          ||= "web"
  self.tblworks_DateTimeStamp     ||= Time.now
  self.tblWorks_Description       ||= ""
  self.CISVersionDate             ||= "web"
  self.tblWorks_IsHasTransactions ||= 0
  self.tblworks_RetRelP           ||= 0
end
