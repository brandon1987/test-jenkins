class DesktopSalesInvoice < UserDatabaseRecord
  after_initialize :defaults

  self.table_name = "tblsalesinv"

  alias_attribute :id,                  :tblSalesInv_Id
  alias_attribute :ncode,               :tblSalesInv_NCode
  alias_attribute :date,                :tblSalesInv_Date
  alias_attribute :net,                 :tblSalesInv_Net
  alias_attribute :vat,                 :tblSalesInv_Vat
  alias_attribute :details,             :tblSalesInv_Details
  alias_attribute :contract_id,         :tblSalesInv_XIDContract
  alias_attribute :last_user,           :tblSalesInv_LastUser
  alias_attribute :work,                :tblSalesInv_Work
  alias_attribute :cert_id,             :tblSalesInv_XIDCert
  alias_attribute :ex_ref,              :tblsalesInv_ExRef
  alias_attribute :account_ref,         :tblSalesInv_AcctRef
  alias_attribute :job_ref,             :tblSalesInv_XIDJob
  alias_attribute :type,                :tblSalesInv_Type
  alias_attribute :cert_no,             :tblSalesInv_CertNo
  alias_attribute :dept,                :tblSalesInv_Dept
  alias_attribute :bank_code,           :tblSalesInv_BankCode
  alias_attribute :inv_ref,             :tblsalesInv_InvRef
  alias_attribute :tax_code,            :tblSalesInv_TaxCode
  alias_attribute :header_no,           :tblSalesInv_HeaderNo
  alias_attribute :a_trail,             :tblSalesInv_ATrail
  alias_attribute :last_split,          :tblSalesInv_LastSplit
  alias_attribute :posted_accounts,     :tblSalesInv_PostedAccounts
  alias_attribute :paid,                :tblSalesInv_Paid
  alias_attribute :is_retention,        :tblSalesInv_ISRetention
  alias_attribute :xid_jc,              :tblSalesInv_XIDJC
  alias_attribute :modified,            :tblSalesInv_DateTimeStamp
  alias_attribute :carriage_net,        :tblSalesInv_Carriage_Net
  alias_attribute :carriage_vat,        :tblSalesInv_Carriage_Vat
  alias_attribute :carriage_dept,       :tblSalesInv_Carriage_Dept
  alias_attribute :carriage_tc,         :tblSalesInv_Carriage_TC
  alias_attribute :carriage_nc,         :tblSalesInv_Carriage_NC
  alias_attribute :cust_order_no,       :tblSalesInv_CustomerOrderNo
  alias_attribute :notes_1,             :tblSalesInv_Notes1
  alias_attribute :notes_2,             :tblSalesInv_Notes2
  alias_attribute :notes_3,             :tblSalesInv_Notes3
  alias_attribute :customer_add1,       :tblSalesInv_CustomerADD1
  alias_attribute :customer_add2,       :tblSalesInv_CustomerADD2
  alias_attribute :customer_add3,       :tblSalesInv_CustomerADD3
  alias_attribute :customer_add4,       :tblSalesInv_CustomerADD4
  alias_attribute :customer_add5,       :tblSalesInv_CustomerADD5
  alias_attribute :posted_date,         :tblSalesInv_PostedDate
  alias_attribute :is_cis6,             :tblSalesInv_IsCIS6
  alias_attribute :citb_levy,           :tblSalesInv_CITBLevy
  alias_attribute :site_address_id,     :tblSalesInv_XIDSiteAddress
  alias_attribute :date_due,            :tblSalesInv_DateDue
  alias_attribute :date_completed,      :tblSalesInv_DateCompleted
  alias_attribute :no_of_spits,         :tblSalesInv_NoOfSplits
  alias_attribute :labour,              :tblSalesInv_Labour
  alias_attribute :cis_tax,             :tblSalesInv_CISTAX
  alias_attribute :is_deduction,        :tblSalesInv_IsDeduction
  alias_attribute :app_id,              :tblSalesInv_XIDApp
  alias_attribute :temp_payment,        :tblSalesInv_tmpPayment
  alias_attribute :order_no,            :tblSalesInv_OrderNo
  alias_attribute :tender_ref,          :tblSalesInv_TenderRef
  alias_attribute :tender_id,           :tblSalesInv_TenderID
  alias_attribute :str_type,            :tblSalesInv_StrType
  alias_attribute :cis_version_date,    :CISVersionDate
  alias_attribute :paid_status,         :tblSalesInv_PaidStatus
  alias_attribute :paid_status_changed, :tblSalesInv_DatePaidStatusChanged
  alias_attribute :tran_no,             :tblSalesInv_TranNo
  alias_attribute :last_split_tran_no,  :tblSalesInv_LastSplitTranNo
  alias_attribute :invoicing_type,      :tblSalesInv_InvoicingType
  alias_attribute :split_record_no,     :tblSalesInv_splitRecordNo
  alias_attribute :number,              :tblSalesInv_Number

  def save_items(items)
    return true
  end

  def defaults
    self.work                ||= 0
    self.cert_id             ||= -1
    self.ex_ref              ||= ""
    self.type                ||= 1
    self.cert_no             ||= -1
    self.dept                ||= 0
    self.bank_code           ||= -1
    self.inv_ref             ||= ""
    self.tax_code            ||= 1
    self.header_no           ||= -1
    self.a_trail             ||= -1
    self.last_split          ||= -1
    self.posted_accounts     ||= 0
    self.paid                ||= -1
    self.is_retention        ||= 0
    self.xid_jc              ||= -1
    self.modified            ||= Time.now
    self.carriage_net        ||= 0
    self.carriage_vat        ||= 0
    self.carriage_dept       ||= 0
    self.carriage_tc         ||= 0
    self.carriage_nc         ||= ""
    self.cust_order_no       ||= ""
    self.notes_1             ||= ""
    self.notes_2             ||= ""
    self.notes_3             ||= ""
    self.customer_add1       ||= ""
    self.customer_add2       ||= ""
    self.customer_add3       ||= ""
    self.customer_add4       ||= ""
    self.customer_add5       ||= ""
    self.posted_date         ||= Time.now
    self.is_cis6             ||= "Y"
    self.citb_levy           ||= 0
    self.site_address_id     ||= 0
    self.date_due            ||= "1899-12-30 00:00:00"
    self.date_completed      ||= ""
    self.no_of_spits         ||= 1
    self.labour              ||= 0
    self.cis_tax             ||= 0
    self.is_deduction        ||= 0
    self.app_id              ||= -1
    self.temp_payment        ||= 0
    self.order_no            ||= ""
    self.tender_ref          ||= ""
    self.tender_id           ||= -1
    self.str_type            ||= ""
    self.cis_version_date    ||= "web"
    self.paid_status         ||= -1
    self.paid_status_changed ||= "1899-12-30 00:00:00"
    self.tran_no             ||= -1
    self.last_split_tran_no  ||= -1
    self.invoicing_type      ||= 0
    self.split_record_no     ||= -1
    self.number              ||= 0
  end
end

=begin
tblSalesInv_ISReversed            | double              |      |     | 0   
tblSalesInv_XIDVoucher            | double              |      |     | 0   
tblSalesInv_Credit                | double              |      |     | 0   
tblSalesInv_AmountPaid            | double              |      |     | 0   
tblSalesInv_IsBatch               | tinyint(4)          |      |     | 0   
tblSalesInv_IsItem                | tinyint(4)          |      |     | 0   
tblSalesInv_OldTrail              | int(11)             |      |     | -1  
tblSalesInv_LastYearEndDate       | varchar(255)        |      |     |     
tblSalesInv_OldHeader             | int(11)             |      |     | 0   
tblSalesInv_IsUPdated             | tinyint(4)          |      |     | 0   
tblsalesinv_euronet               | double              |      |     | 0   
tblsalesinv_eurovat               | double              |      |     | 0   
=end
