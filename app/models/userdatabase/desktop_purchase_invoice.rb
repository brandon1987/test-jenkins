# encoding: UTF-8
class DesktopPurchaseInvoice < UserDatabaseRecord
  self.table_name = "tblPurchaseInv"

 # belongs_to :desktop_contract, :foreign_key =>:XIDContract  , :primary_key =>:tblContractId
  #belongs_to :desktop_supplier, :foreign_key =>:tblCert_XID456 , :primary_key =>:tblSupplier_Ref


  alias_attribute :tblPurchaseInv_Id                 ,:Id                                  
  alias_attribute :tblPurchaseInv_XIDCert            ,:XIDCert                                  
  alias_attribute :tblPurchaseInv_CertNo             ,:CertNo                                  
  alias_attribute :tblPurchaseInv_XIDContract        ,:XIDContract                                  
  alias_attribute :tblPurchaseINV_XIDVoucher         ,:XIDVoucher                                  
  alias_attribute :tblPurchaseInv_ISRetention        ,:ISRetention                                  
  alias_attribute :tblPurchaseInv_Date               ,:Date                                  
  alias_attribute :tblPurchaseInv_Work               ,:Work                                  
  alias_attribute :tblPurchaseInv_AcctRef            ,:AcctRef                                  
  alias_attribute :tblPurchaseInv_XIDJob             ,:XIDJob                                  
  alias_attribute :tblPurchaseInv_ExRef              ,:ExRef                                  
  alias_attribute :tblPurchaseInv_Number             ,:Number                                  
  alias_attribute :tblPurchaseInv_Type               ,:Type                                  
  alias_attribute :tblPurchaseInv_NCode              ,:NCode                                  
  alias_attribute :tblPurchaseInv_Dept               ,:Dept                                  
  alias_attribute :tblPurchaseInv_BankCode           ,:BankCode                                  
  alias_attribute :tblPurchaseInv_PostedDate         ,:PostedDate                                  
  alias_attribute :tblPurchaseInv_Details            ,:Details                                  
  alias_attribute :tblPurchaseInv_InvRef             ,:InvRef                                  
  alias_attribute :tblPurchaseInv_Net                ,:Net                                  
  alias_attribute :tblPurchaseInv_Vat                ,:Vat                                  
  alias_attribute :tblPurchaseInv_Credit             ,:Credit                                  
  alias_attribute :tblPurchaseInv_TaxCode            ,:TaxCode                                  
  alias_attribute :tblPurchaseInv_HeaderNo           ,:HeaderNo                                  
  alias_attribute :tblPurchaseInv_ATrail             ,:ATrail                                  
  alias_attribute :tblPurchaseInv_LastSplit          ,:LastSplit                                  
  alias_attribute :tblPurchaseInv_PostedAccounts     ,:PostedAccounts                                  
  alias_attribute :tblPurchaseInv_Paid               ,:Paid                                  
  alias_attribute :tblPurchaseInv_AmountPaid         ,:AmountPaid                                  
  alias_attribute :tblPurchaseInv_IsReversed         ,:IsReversed                                  
  alias_attribute :tblPurchaseInv_XIDJC              ,:XIDJC                                  
  alias_attribute :tblPurchaseInv_CostCode           ,:CostCode                                  
  alias_attribute :tblPurchaseInv_JCCHID             ,:JCCHID                                  
  alias_attribute :tblPurchaseInv_Markup             ,:Markup                                  
  alias_attribute :tblPurchaseInv_LastUser           ,:LastUser                                  
  alias_attribute :tblPurchaseInv_DateTimeStamp      ,:DateTimeStamp                                  
  alias_attribute :tblPurchaseInv_OldTrail           ,:OldTrail                                  
  alias_attribute :tblPurchaseInv_LastYearEndDate    ,:LastYearEndDate                                  
  alias_attribute :tblPurchaseInv_IsDeduction        ,:IsDeduction                                  
  alias_attribute :tblPurchaseInv_IsVoucher          ,:IsVoucher                                  
  alias_attribute :tblPurchaseInv_CITBLevy           ,:CITBLevy                                  
  alias_attribute :CISVersionDate                    ,:cisversiondate                               
  alias_attribute :tblPurchaseInv_tmpPayment         ,:tmpPayment                                  
  alias_attribute :tblPurchaseInv_XIDMaintenanceTask ,:XIDMaintenanceTask                                  
  alias_attribute :tblPurchaseInv_TranNo             ,:TranNo                                  
  alias_attribute :tblPurchaseInv_LastSplitTranNo    ,:LastSplitTranNo                                  
  alias_attribute :tblPurchaseInv_splitRecordNo      ,:splitRecordNo                                  
  alias_attribute :tblPurchaseInv_isdisputed         ,:isdisputed                                  



end
