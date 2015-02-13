# encoding: UTF-8
class DesktopCertificate < UserDatabaseRecord
  self.table_name = "tblcertificates"

  belongs_to :desktop_contract, :foreign_key =>:tblCert_XIDContract , :primary_key =>:tblContractId
  belongs_to :desktop_supplier, :foreign_key =>:tblCert_XID456 , :primary_key =>:tblSupplier_Ref
  has_many :desktop_purchase_invoice , :foreign_key=>:tblPurchaseInv_XIDCert ,:primary_key=>:tblCert_ID

  alias_attribute :id                                ,:tblCert_ID
  alias_attribute :number                            ,:tblCert_Number    
  alias_attribute :workno                            ,:tblCert_WorkNo    
  alias_attribute :xidcontract                       ,:tblCert_XIDContract         
  alias_attribute :xidworks                          ,:tblCert_XIDWorks      
  alias_attribute :xid456                            ,:tblCert_XID456    
  alias_attribute :xidjob                            ,:tblCert_XIDJob    
  alias_attribute :date                              ,:tblCert_Date  
  alias_attribute :duedate                           ,:tblCert_DueDate     
  alias_attribute :details                           ,:tblCert_Details     
  alias_attribute :datevaluation                     ,:tblCert_DateValuation           
  alias_attribute :gross                             ,:tblCert_Gross   
  alias_attribute :dayworks                          ,:tblCert_Dayworks      
  alias_attribute :variations                        ,:tblCert_Variations        
  alias_attribute :subtotal                          ,:tblCert_SubTotal      
  alias_attribute :retention                         ,:tblCert_Retention       
  alias_attribute :discount                          ,:tblCert_Discount      
  alias_attribute :retpercent                        ,:tblCert_RetPerCent        
  alias_attribute :dispercent                        ,:tblCert_DisPerCent        
  alias_attribute :dis_method                        ,:tblCert_Dis_Method        
  alias_attribute :netamount                         ,:tblCert_NetAmount       
  alias_attribute :previous                          ,:tblCert_Previous      
  alias_attribute :previousret                       ,:tblCert_PreviousRet         
  alias_attribute :previousdis                       ,:tblCert_PreviousDis         
  alias_attribute :previousdw                        ,:tblCert_PreviousDW        
  alias_attribute :previousv                         ,:tblCert_PreviousV       
  alias_attribute :netdue                            ,:tblCert_NetDue    
  alias_attribute :labour                            ,:tblCert_Labour    
  alias_attribute :contra                            ,:tblCert_Contra    
  alias_attribute :citblevy                          ,:tblCert_CITBLevy      
  alias_attribute :cibtlevypcent                     ,:tblCert_CIBTLevyPCent           
  alias_attribute :allowcistax                       ,:tblCert_AllowCisTax         
  alias_attribute :cistaxrate                        ,:tblCert_CISTAXRate        
  alias_attribute :cistax                            ,:tblCert_CISTax    
  alias_attribute :vat                               ,:tblCert_Vat 
  alias_attribute :vatcode                           ,:tblCert_VatCode     
  alias_attribute :vatrate                           ,:tblCert_VatRate     
  alias_attribute :previousvat                       ,:tblCert_PreviousVat         
  alias_attribute :previouscistax                    ,:tblCert_PreviousCISTax            
  alias_attribute :payamount                         ,:tblCert_PayAmount       
  alias_attribute :account_ref                       ,:tblCert_Account_ref         
  alias_attribute :account_name                      ,:tblCert_Account_Name          
  alias_attribute :exref                             ,:tblCert_ExRef   
  alias_attribute :ref                               ,:tblCert_Ref 
  alias_attribute :ispaid                            ,:tblCert_IsPaid    
  alias_attribute :previouslabour                    ,:tblcert_PreviousLabour            
  alias_attribute :isreversed                        ,:tblCert_IsReversed        
  alias_attribute :isposted                          ,:tblCert_IsPosted      
  alias_attribute :ispostsagejobcost                 ,:tblCert_IsPostSageJobCost               
  alias_attribute :xidjcsagejobid                    ,:tblcert_XIDJCSageJobID            
  alias_attribute :xidjcsagesupplierid               ,:tblcert_XIDJCSageSupplierID                 
  alias_attribute :xidjcsagetranid                   ,:tblcert_XIDJCSageTranID             
  alias_attribute :xidjcsagecostidm                  ,:tblcert_XIDJCSageCostIDM              
  alias_attribute :xidjcsagecostidl                  ,:tblcert_XIDJCSageCostIDL              
  alias_attribute :xidappl                           ,:tblCert_XIDAppl     
  alias_attribute :costcodel                         ,:tblCert_CostCodeL       
  alias_attribute :costcodem                         ,:tblCert_CostCodeM       
  alias_attribute :dept                              ,:tblCert_Dept  
  alias_attribute :markupl                           ,:tblcert_MarkupL     
  alias_attribute :markupm                           ,:tblcert_MarkupM     
  alias_attribute :retlabour                         ,:tblcert_RetLabour       
  alias_attribute :dislabour                         ,:tblcert_DisLabour       
  alias_attribute :citblabour                        ,:tblcert_CITBLabour        
  alias_attribute :previouscitb                      ,:tblcert_PreviousCITB          
  alias_attribute :lastuser                          ,:tblCert_LastUser      
  alias_attribute :datetimestamp                     ,:tblCert_DateTimeStamp           
  alias_attribute :previouscontras                   ,:tblCert_PreviousContras             
  alias_attribute :iscis6                            ,:tblCert_IsCIS6    
  alias_attribute :xidtender                         ,:tblCert_XIDTender       
  alias_attribute :ncodelabourpi                     ,:tblCert_NCodeLabourPI           
  alias_attribute :ncodematerialspi                  ,:tblCert_NCodeMaterialsPI              
  alias_attribute :retrelease                        ,:tblCert_RetRelease        
  alias_attribute :retreleaseprev                    ,:tblCert_RetReleasePrev            
  alias_attribute :retreleaselabour                  ,:tblCert_RetReleaseLabour              
  alias_attribute :retreleaselabourprev              ,:tblCert_RetReleaseLabourPrev                  
  alias_attribute :xidcontracttender                 ,:tblCert_XIDContractTender               
  alias_attribute :citbmethod                        ,:tblCert_CITBMethod        
  alias_attribute :ncodecitb                         ,:tblCert_NCodeCITB       
  alias_attribute :citbold                           ,:tblCert_CITBOld     
  alias_attribute :citboldprev                       ,:tblCert_CITBOldPrev         
  alias_attribute :refjournal                        ,:tblCert_RefJournal        
  alias_attribute :datejournal                       ,:tblCert_DateJournal         
  alias_attribute :istimesheet                       ,:tblCert_IsTimeSheet         
  alias_attribute :cisversiondate                    ,:CISVersionDate    
  alias_attribute :xidpo                             ,:tblCert_XIDPO   
  alias_attribute :wipdate                           ,:tblCertificates_WIPDate             
  alias_attribute :allocatewip                       ,:tblCertificates_AllocateWIP                 
  alias_attribute :allocatewiplab                    ,:tblCertificates_AllocateWIPLab                    
  alias_attribute :wipdatelab                        ,:tblCertificates_WIPDateLab                
  alias_attribute :materialsonsite                   ,:tblCert_MaterialsOnSite             
  alias_attribute :materialsonsiteprev               ,:tblCert_MaterialsOnSitePrev                 
  alias_attribute :isproblemwithposting              ,:tblCert_IsProblemWithPosting                  
  alias_attribute :tempmatonsitecurrent              ,:tblCertificates_TempMatOnSiteCurrent                          
  alias_attribute :tempdwcurrent                     ,:tblCertificates_TempDWCurrent                   
  alias_attribute :tempvarcurrent                    ,:tblCertificates_TempVarCurrent                    
  alias_attribute :tempretcurrent                    ,:tblCertificates_TempRetCurrent                    
  alias_attribute :tempdiscurrent                    ,:tblCertificates_TempDisCurrent                    
  alias_attribute :tempgrosscurrent                  ,:tblCertificates_TempGrossCurrent                      
  alias_attribute :tempnetamtcurrent                 ,:tblCertificates_TempNetAmtCurrent                       
  alias_attribute :tempcistaxcurrent                 ,:tblCertificates_TempCISTaxCurrent                       
  alias_attribute :tempvatcurrent                    ,:tblCertificates_TempVatCurrent                    
  alias_attribute :tempcitbcurrent                   ,:tblCertificates_TempCITBCurrent                     
  alias_attribute :tempretrelcurrent                 ,:tblCertificates_TempRetRelCurrent                       
  alias_attribute :tempretrellabcurrent              ,:tblCertificates_TempRetRelLabCurrent                          
  alias_attribute :xidsiteaddress                    ,:tblCert_XIDSiteAddress            
  alias_attribute :xidmaintenancetask                ,:tblCertificates_XIDMaintenanceTask                        
  alias_attribute :maintenancemarkup                 ,:tblCert_MaintenanceMarkup               
  alias_attribute :materials                         ,:tblCert_Materials       
  alias_attribute :costm                             ,:tblCert_CostM   
  alias_attribute :costl                             ,:tblCert_CostL   
  alias_attribute :withelddetails                    ,:tblcertificates_WitheldDetails                    
  alias_attribute :isdisputed                        ,:tblCert_isdisputed        
  alias_attribute :disputeinfo                       ,:tblCert_disputeinfo         
  alias_attribute :insuranceexcess                   ,:tblCertificates_InsuranceExcess 

  def certgross()
    return self.tblCert_SubTotal-(self.tblCert_Previous+self.tblCert_PreviousDis+self.tblCert_PreviousRet-self.tblCert_RetReleasePrev+self.tblCert_CITBOldPrev)
  end

  def paidamt()
    return self.desktop_purchase_invoice.sum("tblPurchaseInv_AmountPaid", :group =>:XIDCert)
#    return self.desktop_purchase_invoice.sum("CASE WHEN tblPurchaseInv_Type=6 THEN tblPurchaseInv_AmountPaid ELSE tblPurchaseInv_AmountPaid*-1 END")
  end

  def outstanding()
    return self.tblCert_PayAmount-paidamt
  end

  def currentvariations()
    return self.tblCert_Variations-self.tblCert_PreviousV
  end

end

#Sanitised query for certs
###SELECT 
###tblCertificates.tblCert_ID AS ID,
###tblCertificates.tblCert_WorkNo AS WorkNo,
###tblCertificates.tblCert_XID456 AS Contractor,
###tblSuppliers.tblSupplier_Name AS SubName,
###tblCertificates.tblCert_XIDJob AS Job,
###CASE WHEN ISNULL(tblMaintenanceTask_Ref1) THEN '' ELSE tblMaintenanceTask_Ref1 END AS MJob,
###tblCertificates.tblCert_Date AS CertDate,tblCertificates.tblCert_Ref AS Ref,
###(tblCert_SubTotal -(tblCert_Previous+ tblcert_PreviousDis+tblcert_PreviousRet - tblcert_RetReleasePrev+ tblcert_CITBOldPrev))AS Gross,
###tblCertificates.tblCert_NetDue AS NetDue, 
###tblCertificates.tblCert_Labour AS Labour,
###tblcert_materials AS Materials,
###tblCertificates.tblCert_Vat AS Vat,
###tblCertificates.tblCert_CISTax AS CisTax,
###tblCertificates.tblCert_PayAmount AS PayAmount,
###SUM(CASE WHEN tblPurchaseInv_Type=6 THEN tblPurchaseInv_AmountPaid ELSE tblPurchaseInv_AmountPaid*-1 END) AS AmtPaid,  
###tblCert_PayAmount-SUM(CASE WHEN tblPurchaseInv_Type=6 THEN tblPurchaseInv_AmountPaid ELSE tblPurchaseInv_AmountPaid*-1 END) AS Outstanding,
###tblCert_Number AS CertNum ,
###tblCert_DateTimeStamp AS Created,
###tblCertificates.tblCert_Retention-tblCertificates.tblCert_PreviousRet AS Ret,
###tblCertificates.tblCert_RetRelease-tblCert_RetReleasePrev AS RetRelease,
###(tblCertificates.tblCert_Retention-tblCertificates.tblCert_PreviousRet)-(tblCertificates.tblCert_RetRelease-tblCert_RetReleasePrev) AS NetRet,
###tblCertificates.tblCert_Discount-tblCertificates.tblCert_PreviousDis AS Discount,
###tblCertificates.tblCert_CITBLevy- tblCertificates.tblcert_PreviousCITB AS CITBLevy,
###tblCertificates.tblCert_Dayworks- tblCertificates.tblCert_PreviousDW AS Dayworks,
###tblCertificates.tblCert_Variations- tblCertificates.tblCert_PreviousV AS Variations,
###tblCertificates.tblCert_Details AS Details,
###SUM(CASE WHEN tblCertDeductions.tblcertdeductions_sdotype=6 THEN tblCertDeductions.tblCertDeductions_Net WHEN tblCertDeductions.tblcertdeductions_sdotype=7 THEN tblCertDeductions.tblCertDeductions_Net*-1 ELSE 0 END)  AS Contras,
###tblCertificates.tblCert_Retention AS CumRet,
###tblCertificates.tblCert_RetRelease AS CumRetRel,
###tblCertificates.tblCert_Retention - tblCertificates.tblCert_RetRelease AS CumRetOS,
###tblCertificates.tblCert_Discount AS CumDiscount,
###tblCertificates.tblCert_CITBLevy AS CumCITBLevy,
###tblCertificates.tblCert_NetAmount AS NetAmount,
###tblCertificates.tblCert_SubTotal AS SubTotal,
###tblCertificates.tblCert_CostCodeL AS CostCodeL,
###tblCertificates.tblCert_CostCodeM AS CostCodeM,
###tblCertificates.tblCert_NCodeLabourPI AS NCodeL,
###tblCertificates.tblCert_NCodeMaterialsPI AS NCodeM,
###tblTender.tblTender_Ref AS Tender,
###tblTender.tblTender_Ref AS XTender,
###tblCertificates.tblCert_Dept AS Dept,
###tblCertificates.tblCert_ExRef AS ExRef,
###CASE WHEN  tblCertificates.tblCert_IsPosted = '-1' THEN 'Y' ELSE 'N' END  AS Posted,
###tblContracts.tblContractStatus, tblCertificates.tblCert_RefJournal AS JournalRef,
###tblCertificates.tblCert_DateJournal AS JournalDate,
###tblCertificates.tblCert_IsProblemWithPosting AS SavedError,
###tblCert_MaintenanceMarkup,
###tblPOs.tblPOs_PONo AS PONo,
###tblCertificates.tblCert_XIDAppl AS AppID,
###tblCert_XIDPO ,
###tblCertificates_XIDMaintenanceTask,tblCert_DateValuation AS DateValuation,
###tblCert_Previous AS Previous,tblCert_PreviousRet AS PreviousRet,
###tblCert_PreviousDis AS PreviousDis,
###tblCert_PreviousDW AS PreviousDW,
###tblCert_PreviousV AS PreviousV,
###tblCert_PreviousVat AS PreviousVat,
###tblCert_PreviousCISTax AS PreviousCIStax,
###tblCert_PreviousLabour AS PreviousLabour,
###tblCert_PreviousCITB AS PreviousCITB,
###tblCert_PreviousContras AS PreviousContras,
###tblcert_RetLabour AS RetLabour,
###tblcert_DisLabour AS DisLabour,
###tblcert_CITBLabour AS CITBLabour,
###tblCert_RetReleasePrev AS RetReleasePrev,
###tblCert_RetReleaseLabour AS RetReleaseLabour,
###tblCert_RetReleaseLabourPrev AS RetReleaseLabourPrev,
###tblCert_VatRate AS VatRate, 
###tblCert_XIDContract AS XIDContract ,
###CASE WHEN tblCert_isdisputed = '0' THEN 'N' ELSE 'Y' END AS isDisputed ,
###tblCert_DueDate AS DueDate 
### 
###FROM tblCertificates 
###LEFT JOIN tblContracts ON tblContracts.tblContractId = tblCertificates.tblCert_XIDContract 
###LEFT JOIN tblPOs ON tblCertificates.tblCert_XIDPO = tblPOs.tblPOs_ID  
###LEFT JOIN tblTender ON tblCertificates.tblCert_XIDContractTender = tblTender.tblTender_ID  
###LEFT JOIN tblSuppliers ON tblCertificates.tblCert_XID456 = tblSuppliers.tblSupplier_Ref  
###LEFT JOIN tblmaintenancetask ON tblMaintenanceTask_Id=tblCertificates.tblCertificates_XIDMaintenanceTask
###LEFT JOIN tblCertDeductions ON tblCertDeductions.tblCertDeductions_XIDCert=tblCertificates.tblCert_ID
###LEFT JOIN tblpurchaseinv ON tblPurchaseInv_XIDCert=tblCertificates.tblCert_ID
###
###
###WHERE  TRIM(tblCertificates.tblCert_XID456) <> ''   
###GROUP BY tblcertificates.tblCert_ID
###
###ORDER BY  tblCertificates.tblCert_XID456, tblCertificates.tblCert_XIDJob, tblCertificates.tblCert_Number
###
###