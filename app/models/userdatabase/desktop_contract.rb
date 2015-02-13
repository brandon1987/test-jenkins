# encoding: UTF-8

include DesktopContractAliases

class DesktopContract < UserDatabaseRecord
  before_create :defaults

  after_create :create_related_work
  self.table_name = "tblContracts"

  alias_attribute :id,                   :tblContractId
  alias_attribute :job_no,               :tblContractXidJobNo
  alias_attribute :description,          :tblContractDescription
  alias_attribute :status,               :tblContractStatus
  alias_attribute :customer_ref,         :tblContractXIDCustomer
  alias_attribute :customer_name,        :tblContractCustomerName
  alias_attribute :value,                :tblContractValue
  alias_attribute :date,                 :tblContractDate
  alias_attribute :completed_date,       :tblContractCompletedDate
  alias_attribute :end_date,             :tblContractEndDate
  alias_attribute :value_from_tenders,   :tblcontracts_CalculateTotalByTender
  alias_attribute :dayworks,             :tblcontracts_Dayworks
  alias_attribute :variations,           :tblcontracts_Variations
  alias_attribute :job_analysis,         :tblContractXIDJobAnalysis
  alias_attribute :project_manager,      :tblContractProjectManager
  alias_attribute :special_instructions, :tblContractSpecialInst
  alias_attribute :order_no,             :tblContractXref
  alias_attribute :classification,       :tblContractType
  alias_attribute :memo_id,              :tblContractXIDMemo
  alias_attribute :cis_version,          :CISVersionDate
  alias_attribute :default_site_address, :tblContractXIDDefaultSA

  # defaults
  alias_attribute :retention_percentage,           :tblContractDefRetention
  alias_attribute :final_retention_percentage,     :tblContractDefRetentionFinal
  alias_attribute :discount_percentage,            :tblContractDefDiscount
  alias_attribute :retention_period,               :tblContractDefRetPeriod
  alias_attribute :retention_and_discount_method,  :tblContractDefDiscountMethod
  alias_attribute :pay_group,                      :tblContractXIDPayGroup

  alias_attribute :materials,                      :tblContractBudgetMaterials
  alias_attribute :products,                       :tblContractBudgetProducts
  alias_attribute :sublabour,                      :tblContractBudgetSubLabour
  alias_attribute :submaterials,                   :tblContractBudgetSubMaterials
  alias_attribute :labour,                         :tblContractBudgetLabour
  alias_attribute :purchase,                       :tblContractBudgetPO

  alias_attribute :notify_materials,               :tblContractNotifyMaterials
  alias_attribute :notify_products,                :tblContractNotifyStock
  alias_attribute :notify_sublabour,               :tblContractNotifySubLabour
  alias_attribute :notify_submaterials,            :tblContractNotifySubMaterials
  alias_attribute :notify_labour,                  :tblContractNotifyLabour
  alias_attribute :notify_purchase,                :tblContractNotifyPO

  belongs_to :desktop_contract_status, :foreign_key => :tblContractStatus
  belongs_to :desktop_contract_type,   :foreign_key => :tblContractType
  belongs_to :desktop_job_analysis,    :foreign_key => :tblContractXIDJobAnalysis
  belongs_to :desktop_customer,     	 :foreign_key => :tblContractXIDCustomer,:primary_key => :tblCustomer_Ref
  has_one    :desktop_site_address,    :foreign_key => :tblAddresses_ID, :primary_key => :tblContractXIDDefaultSA

  def total_value
    value.to_f + dayworks.to_f + variations.to_f
  end

  # Given an instance of a Quote model, creates a new contract based on the
  # quote values.
  def DesktopContract.new_from_quote(quote)
    new_contract = DesktopContract.new

    if CompanyPreferences.quote_num_to_contract_num
      new_contract.job_no = quote.number
    else
      new_contract.job_no = DesktopContract.next_job_no
    end

    new_contract.tblContractDate = Time.now

    # Set some defaults based on the seed quote
    new_contract.value           = quote.net
    new_contract.description     = quote.details

    new_contract.set_customer_from_quote(quote)

    return new_contract
  end

  def set_customer_from_quote(quote)
    if quote.xid_customer != -1
      customer = Customer.find(quote.xid_customer)
      customer.send_to_desktop unless customer.has_desktop_copy?

      desktop_customer = DesktopCustomer.where(id: customer.link_id)
                          .select(:ref, :name).first

      if desktop_customer # If, for whatever reason, the customer table has gone out of sync
        self.customer_ref  = desktop_customer.ref
        self.customer_name = desktop_customer.name
      end
    end
  end

  def DesktopContract.next_job_no
    return "" unless DesktopDefault.autonumber_contracts?

    pattern          = DesktopJobNoPatterns.where(jobdefault: -1).first
    existing_job_nos = DesktopContract.pluck(:job_no)

    if !pattern.nil?
      patternchars=pattern.pattern.split(//)
      startno=pattern.startno.split(//)
      sanitisedstartno=""
      startno.each_with_index do|x,i|
        sanitisedstartno<<x if patternchars[i]=~/[&%]/               #get the startno without anything except for characters that can be incremented.
      end

      finaljobno=""
      until (!existing_job_nos.include? finaljobno) && finaljobno!=""
        sanitisedstartno=sanitisedstartno.next                       #Increment the number by 1
        sanitisedstartnoarray=sanitisedstartno.split(//)
        i=0
        finaljobno=""
        patternchars.each do |x|
          if x=~ /[&%]/
            finaljobno<<sanitisedstartnoarray [i]
            i+=1
          end
          finaljobno<< x if x=~/[^£$&%]/                 #reassemble the number with the constants and check to see if this number is not yet used. If it is, increment again.
        end
      end

      return finaljobno
    else
      return "patternerror"
    end
  end

  # This is called automatically after a contract is created
  def create_related_work
    DesktopWork.create_for_contract(self)
  end

  def get_eligible_subbies
    works = DesktopWork.where(contract_id: id).pluck(:ref)

    subbies = DesktopSupplier.select(:id, :ref, :name, :tax_treatment).select { |x| x.can_be_subbie? }
    subbies = subbies.reject { |subbie| works.include?(subbie.ref) }

    return subbies
  end

  def add_all_eligible_subbies
    subbies = get_eligible_subbies

    defaults = DesktopDefault.select(
      :subbie_retention_percentage,
      :subbie_discount_percentage,
      :subbie_retention_period,
      :subbie_retention_and_discount_method
    ).first

    subbies.each do |subbie|
      DesktopWork.new({
        :number              => DesktopWork.next_number_for_contract(id),
        :ref                 => subbie.ref,
        :contract_id         => id,
        :contractor_name     => subbie.name,
        :retention           => defaults.subbie_retention_percentage,
        :ret_period          => defaults.subbie_retention_period,
        :discount_percentage => defaults.subbie_discount_percentage,
        :discount_method     => defaults.subbie_retention_and_discount_method
      }).save
    end
  end

  def defaults
    self.job_no               ||= ""
    self.description          ||= ""
    self.status               ||= 1
    self.customer_ref         ||= ""
    self.customer_name        ||= ""
    self.value                ||= 0
    self.date                 ||= Time.now
    self.value_from_tenders   ||= 0
    self.dayworks             ||= 0
    self.variations           ||= 0
    self.job_analysis         ||= -1
    self.project_manager      ||= ""
    self.special_instructions ||= ""
    self.order_no             ||= ""
    self.classification       ||= 0
    self.memo_id              ||= -1
    self.cis_version          ||= "web"

    # defaults
    default_values = DesktopDefault.first

    self.retention_percentage          ||= default_values.subbie_retention_percentage
    self.final_retention_percentage    ||= default_values.subbie_final_retention_percentage
    self.discount_percentage           ||= default_values.subbie_discount_percentage
    self.retention_period              ||= default_values.subbie_retention_period
    self.retention_and_discount_method ||= default_values.subbie_retention_and_discount_method

    self.materials                     ||= 0
    self.products                      ||= 0
    self.sublabour                     ||= 0
    self.submaterials                  ||= 0
    self.labour                        ||= 0
    self.purchase                      ||= 0

    self.notify_materials              ||= 0
    self.notify_products               ||= 0
    self.notify_sublabour              ||= 0
    self.notify_submaterials           ||= 0
    self.notify_labour                 ||= 0
    self.notify_purchase               ||= 0

    # Un-aliased gubbins
    self.tblContractDayWorkUpLiftL             ||= 0
    self.tblContractDayWorkUpLiftM             ||= 0
    self.tblContractDayWorkUpLiftP             ||= 0
    self.tblContractXIDJobNoAlpha              ||= ""
    self.tblContractXIDPOP                     ||= -1
    self.tblContracts_JCJobID                  ||= ""
    self.tblContracts_LastUser                 ||= "web"
    #self.tblContracts_DateTimeStamp            ||= "0000-00-00 00:00:00"
    self.tblContractXIDPayGroup                ||= -1
    self.tblContract_TradeContacts             ||= ""
    self.tblContract_CustomerPhone             ||= ""
    self.tblcontracts_NEWWIPPercentageComplete ||= 0
    #self.tblcontracts_NEWWIPValuationDate      ||= "0000-00-00 00:00:00"
    self.tblcontracts_NEWWIPValuation          ||= 0
    self.tblContractXIDDefaultSA               ||= -1
    self.tblcontracts_NEWWIPAdjustmentValue    ||= 0
    self.tblcontracts_ContractClaim            ||= 0
  end
end
