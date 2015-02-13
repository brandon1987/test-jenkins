class DesktopInvoiceItem < UserDatabaseRecord
  after_initialize :defaults

  self.table_name = "tblinvoiceitem"

  alias_attribute :id,                  :tblInvoiceItem_ID
  alias_attribute :invoice_id,          :tblInvoiceItem_Number
  alias_attribute :quantity,            :tblInvoiceItem_ItemQuantity
  alias_attribute :unit_price,          :tblInvoiceItem_ItemPrice
  alias_attribute :item,                :tblInvoiceItem_Item                 
  alias_attribute :description,         :tblInvoiceItem_Description          
  alias_attribute :unit_of_sale,        :tblInvoiceItem_Unit_of_sale         
  alias_attribute :discount_rate,       :tblInvoiceItem_DiscountRate         
  alias_attribute :delivery_date,       :tblInvoiceItem_DeliveryDate         
  alias_attribute :ncode,               :tblInvoiceItem_NominalCode          
  alias_attribute :dept,                :tblInvoiceItem_Dept                 
  alias_attribute :tax_code,            :tblInvoiceItem_taxCode              
  alias_attribute :net_amount,          :tblInvoiceItem_NetAmount            
  alias_attribute :contract_id,         :tblInvoiceItem_XIDContract          
  alias_attribute :comment_1,           :tblInvoiceItem_Comment1             
  alias_attribute :comment_2,           :tblInvoiceItem_Comment2             
  alias_attribute :vat,                 :tblInvoiceItem_Vat                  
  alias_attribute :date,                :tblInvoiceItem_DateTimeStamp        
  alias_attribute :last_user,           :tblInvoiceItem_Lastuser             
  alias_attribute :header_no,           :tblInvoiceItem_HeaderNo             
  alias_attribute :a_trail_no,          :tblInvoiceItem_AtrailNo             
  alias_attribute :amount_paid,         :tblInvoiceItem_AmountPaid           
  alias_attribute :is_paid,             :tblInvoiceItem_IsPaid               
  alias_attribute :acct_ref,            :tblInvoiceItem_AcctRef              
  alias_attribute :is_updated,          :tblInvoiceItem_IsUPdated            
  alias_attribute :cis_version_date,    :CISVersionDate                      
  alias_attribute :paid_status,         :tblInvoiceItem_PaidStatus           
  alias_attribute :paid_status_changed, :tblInvoiceItem_DatePaidStatusChanged
  alias_attribute :tender_id,           :tblInvoiceItem_XIDTender            
  alias_attribute :maintenance_task_id, :tblInvoiceItem_XIDMaintenanceTask   
  alias_attribute :tran_no,             :tblInvoiceItem_TranNo               
  alias_attribute :product_code,        :tblInvoiceItem_ProductCode          
  alias_attribute :split_record_no,     :tblInvoiceItem_splitRecordNo        
  alias_attribute :stock_tran_id,       :tblInvoiceItem_XIDStockTran         
  alias_attribute :euro_net,            :tblinvoiceitem_euronet              
  alias_attribute :euro_vat,            :tblinvoiceitem_eurovat              
  alias_attribute :euro_price,          :tblinvoiceitem_euroPrice    

  def defaults
    self.invoice_id          ||= -1
    self.quantity            ||= 0
    self.unit_price          ||= 0
    self.item                ||= 1
    self.description         ||= ""
    self.unit_of_sale        ||= 0
    self.discount_rate       ||= 0
    self.delivery_date       ||= "1899-12-30 00:00:00"
    self.ncode               ||= 4000
    self.dept                ||= 0
    self.tax_code            ||= 1
    self.net_amount          ||= 0
    self.contract_id         ||= -1
    self.comment_1           ||= ""
    self.comment_2           ||= ""
    self.vat                 ||= 0
    self.date                ||= Time.now
    self.last_user           ||= ""
    self.header_no           ||= 0
    self.a_trail_no          ||= 0
    self.amount_paid         ||= 0
    self.is_paid             ||= 0
    self.acct_ref            ||= ""
    self.is_updated          ||= 0
    self.cis_version_date    ||= "web"
    self.paid_status         ||= -1
    self.paid_status_changed ||= "1899-12-30 00:00:00"
    self.tender_id           ||= -1
    self.maintenance_task_id ||= -1
    self.tran_no             ||= -1
    self.product_code        ||= ""
    self.split_record_no     ||= -1
    self.stock_tran_id       ||= -1
    self.euro_net            ||= 0
    self.euro_vat            ||= 0
    self.euro_price          ||= 0

    # deprecated fields, but want them to be non null just in case
    self.tblInvoiceItem_Quantity   ||= 0
    self.tblInvoiceItem_Unit_Price ||= 0
  end        
end

# DEPRECATION NOTE
# The fields `tblInvoiceItem_Quantity` and `tblInvoiceItem_Unit_Price` are
# quite probably deprecated. Use `tblInvoiceItem_ItemQuantity` and
# `tblInvoiceItem_ItemPrice` instead.