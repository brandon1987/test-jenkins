class DesktopDefault < UserDatabaseRecord
  self.table_name = "tblCDefaults"

  alias_attribute :autonumber_contracts, :tblCDefaults_IsGenerateJobNo

  alias_attribute :subbie_retention_percentage,          :tblCDefaults_RetP
  alias_attribute :subbie_final_retention_percentage,    :tblCDefaults_RetFinalP
  alias_attribute :subbie_discount_percentage,           :tblCDefaults_DisP
  alias_attribute :subbie_retention_period,              :tblCDefaults_RetPeriod
  alias_attribute :subbie_retention_and_discount_method, :tblCDefaults_DisMethod
  alias_attribute :desktop_date,                         :tblCDefaults_DatabaseDate

  def DesktopDefault.autonumber_contracts?
    DesktopDefault.first.autonumber_contracts != 0
  end

  def DesktopDefault.get(value)
    DesktopDefault.select(value).first[value]
  end
end

=begin
| tblCDefaults_Id                               | int(11)      |      | PRI | NULL    | auto_increment |
| tblcdefaults_isPostToStock                    | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_Index                            | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_LabourUpliftP                    | double       | YES  |     | NULL    |                |
| tblCDefaults_MatUpliftP                       | double       | YES  |     | NULL    |                |
| tblCDefaults_PlantUpliftP                     | double       | YES  |     | NULL    |                |
| tblCDefaults_VatRate                          | double       | YES  |     | NULL    |                |
| tblCDefaults_VatRegYN                         | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_VatCode                          | smallint(6)  | YES  |     | NULL    |                |
| tblCDefaults_CISRateYN                        | smallint(6)  | YES  |     | NULL    |                |
| tblCDefaults_CISRate                          | double       | YES  |     | NULL    |                |
| tblCDefaults_CITBLevy                         | double       | YES  |     | NULL    |                |
| tblCDefaults_ISCITBYN                         | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_CITBMethod                       | smallint(6)  | YES  |     | NULL    |                |
| tblCDefaults_NCodeInTaxSC                     | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeTaxRecoverable              | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_Dept                             | smallint(6)  | YES  |     | NULL    |                |
| tblCDefaults_StartDateWN                      | datetime     | YES  |     | NULL    |                |
| tblCDefaults_MaxWeeks                         | smallint(6)  | YES  |     | NULL    |                |
| tblCDefaults_OffSetApp                        | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_OffSetCert                       | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_OffSetVar                        | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_OffSetDW                         | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_CurrencySystem                   | smallint(6)  | YES  |     | NULL    |                |
| tblCDefaults_CRetP                            | double       | YES  |     | NULL    |                |
| tblCDefaults_CRetFinalP                       | double       | YES  |     | NULL    |                |
| tblCDefaults_CRetPeriod                       | smallint(6)  | YES  |     | NULL    |                |
| tblCDefaults_CDisP                            | double       | YES  |     | NULL    |                |
| tblCDefaults_CDisMethod                       | smallint(6)  | YES  |     | NULL    |                |
| tblCDefaults_NCodeLabour                      | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeMaterials                   | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeLabourCIS5                  | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeMaterialsCIS5               | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeLabourCIS6                  | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeMaterialsCIS6               | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeRetentionSC                 | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeContractPlant               | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeContractMaterials           | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeContractSales               | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeBank                        | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeMissedPosting               | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_PostJobToRef                     | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_PostJobToExRef                   | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_PostJobToDetails                 | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_PostRefToRef                     | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_PostRefToExRef                   | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_LoadSuppliersAtStart             | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_LoadCustomersAtStart             | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_isUseSupplierNCodeSCL            | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_isUseSupplierNCodeSCM            | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_isUseSupplierNCodePlant          | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_isUseSupplierNCodeMaterials      | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_DefCurrencySymbol                | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_Type                             | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_V                                | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_isPostRetention                  | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_isCashAccounting                 | tinyint(4)   | YES  |     | NULL    |                |
| tblCdefaults_CIS                              | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_PostJobToDept                    | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_COST_CIS4_M                      | int(11)      |      |     | 0       |                |
| tblCDefaults_COST_CIS5_M                      | int(11)      |      |     | 0       |                |
| tblCDefaults_COST_CIS6_M                      | int(11)      |      |     | 0       |                |
| tblCDefaults_COST_CISN_M                      | int(11)      |      |     | 0       |                |
| tblCDefaults_COST_CIS4_L                      | int(11)      |      |     | 0       |                |
| tblCDefaults_COST_CIS5_L                      | int(11)      |      |     | 0       |                |
| tblCDefaults_COST_CIS6_L                      | int(11)      |      |     | 0       |                |
| tblCDefaults_COST_CISN_L                      | int(11)      |      |     | 0       |                |
| tblCDefaults_Application                      | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsUseSuppLCC_CIS4                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsUseSuppLCC_CIS5                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsUseSuppLCC_CIS6                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsUseSuppMCC_CIS4                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsUseSuppMCC_CIS5                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsUseSuppMCC_CIS6                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_CITBLevyCustomer                 | double       | YES  |     | NULL    |                |
| tblCDefaults_NCodeMaterialsCISN               | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeLabourCISN                  | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_IsUseSuppLCC_CISN                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsUseSuppMCC_CISN                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_CM                               | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeCITB                        | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_IsPostACToDetails                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_ISLogin                          | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_NCodeAppliedGross                | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeAppliedDiscount             | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeAppliedRetention            | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeApplicationOs               | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeCertifiedGross              | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeCertifiedDiscount           | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeCertifiedRetention          | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeCITBLevySC                  | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeSubRetention                | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeSubDiscount                 | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeAppliedGrossSub             | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeAppliedDisSub               | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeAppliedRetSub               | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeApplicationOsSub            | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_CustDefNcode                     | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_CustDefTaxCode                   | smallint(6)  | YES  |     | NULL    |                |
| tblCDefaults_CustDefDept                      | smallint(6)  | YES  |     | NULL    |                |
| tblCDefaults_AppScheduleCumCur                | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_IsPostAppRefToCert               | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsPostSingleInvoiceToSage        | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_VCUpdate                         | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_ATClearDate                      | datetime     | YES  |     | NULL    |                |
| tblCDefaults_YCDate                           | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeLabourC2                    | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeLabourRCT                   | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeMaterialsC2                 | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_NCodeMaterialsRCT                | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_Cost_C2_M                        | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_Cost_C2_L                        | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_Cost_RCT_M                       | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_Cost_RCT_L                       | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_IsUseSuppLCC_C2                  | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsUseSuppLCC_RCT                 | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsUseSuppMCC_C2                  | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsUseSuppMCC_RCT                 | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_RCTRate                          | double       | YES  |     | NULL    |                |
| tblCDefaults_IsPostSIJobNoTo_Details          | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_IsChargeOUT                      | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_IsPOPUseLastCostPrice            | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_AlphaJobNo                       | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_IsGenerateJobNo                  | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_PostGrossCertificate             | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_PostGrossCertificateSub          | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_POStartNo                        | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_Proxy                            | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_Port                             | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_IsNewTenderSystem                | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_StockCostDP                      | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_StockQTYDP                       | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_POPUseSupplierDiscount           | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_isMaintenanceAutoNumber          | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_MaintenanceMaterialMarkup        | double       |      |     | 0       |                |
| tblCDefaults_MaintenanceLabourMarkup          | double       |      |     | 0       |                |
| tblCDefaults_MaintenanceSubMarkup             | double       |      |     | 0       |                |
| tblCDefaults_ISPOUseLine50NCode               | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_isStockTranUseDetailandJobno     | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_MaintenanceStockMarkup           | double       | YES  |     | NULL    |                |
| tblCDefaults_MaintenancePOMarkup              | double       | YES  |     | NULL    |                |
| tblCDefaults_MondayStart                      | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_MondayEnd                        | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_TuesdayStart                     | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_TuesdayEnd                       | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_WednesdayStart                   | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_WednesdayEnd                     | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_ThursdayStart                    | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_ThursdayEnd                      | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_FridayStart                      | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_FridayEnd                        | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_SaturdayStart                    | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_SaturdayEnd                      | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_SundayStart                      | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_SundayEnd                        | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_isMondayWorked                   | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_isTuesdayWorked                  | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_isWednesdayWorked                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_isThurdsayWorked                 | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_isFridayWorked                   | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_isSaturdayWorked                 | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_isSundayWorked                   | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_isSyncPoNo                       | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_NCodeCarriage                    | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_AutoInvoiceNoToExRef             | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_AutoJobNoToRef                   | tinyint(4)   |      |     | 0       |                |
| tblCompany_UTR                                | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_ISOneOffFixToPurchaseTaxCodes    | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_PostAutoInvoiceNoToRef           | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_ISOneoffmjobreset                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_ISOneOffTenderTableFill          | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_DefNCUnmatchedTax                | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_DeductionLowRate                 | double       | YES  |     | NULL    |                |
| tblCDefaults_DeductionHighRate                | double       | YES  |     | NULL    |                |
| tblCDefaults_MJInvoiceDescriptionDefault      | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_MJInvoiceComment1Default         | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_MJInvoiceComment2Default         | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_MJInvoiceLongDescriptionDefault  | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_IsNewCIS                         | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_AuthN                            | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_AuthC                            | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_LockForUpdate                    | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_isNewWIP                         | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_IntegrationType                  | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_MessageServer                    | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_MessageQueue                     | varchar(255) | YES  |     | NULL    |                |
| tblcdefaults_allowNegativeStock               | tinyint(4)   | YES  |     | NULL    |                |
| tblcdefaults_IntegrationShortCompanyName      | varchar(255) | YES  |     | NULL    |                |
| tblcdefaults_IntegrationPassword              | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_ErrorMessageQueue                | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_IncomingMessageQueue             | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_OutgoingMessageQueue             | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_IntegrationWebAddress            | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_isShowOnlyIntegrationEmployees   | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_IntelliscanIncomingFolder        | longtext     | YES  |     | NULL    |                |
| tblCDefaults_IntelliscanOutgoingFolder        | longtext     | YES  |     | NULL    |                |
| tblCDefaults_IntelliscanCheckMessageFolders   | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_IntelliscanClientID              | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_IntelliscanSiteID                | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_IntelliscanUserName              | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_IntelliscanPassword              | varchar(255) | YES  |     | NULL    |                |
| tblcdefaults_InitialWipActivate               | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_NCodeCarriageSales               | varchar(255) | YES  |     | 4905    |                |
| tblCDefaults_IsUsePPMethodFeb2010             | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_originTemplatePath               | longtext     | YES  |     | NULL    |                |
| tblCDefaults_originFTPServer                  | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_originFTPUserName                | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_originFTPPassword                | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_isFilterMJobs                    | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_AutoSetCompletionDate            | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_disconnectedModePayroll          | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_SubPORequireInsurance            | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_IntegrationTimeout               | int(11)      |      |     | 0       |                |
| tblCDefaults_AppDetailsToCertDetails          | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsUseFullNCodes                  | int(11)      | YES  |     | NULL    |                |
| tblCDefaults_CisBankCode                      | varchar(255) | YES  |     | NULL    |                |
| tblcdefaults_EuroConversionRate               | double       | YES  |     | NULL    |                |
| tblCDefaults_MJInvoiceHeaderRefDefault        | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_MJInvoiceHeaderExRefDefault      | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_MJInvoiceHeaderOrderNoDefault    | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_ActivateQuickFilterButton        | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_MJInvoiceHeaderDetailsDefault    | varchar(255) | YES  |     | NULL    |                |
| tblCDefaults_IsIrishTax                       | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_DeductionUK_High                 | double       | YES  |     | NULL    |                |
| tblCDefaults_DeductionUK_Low                  | double       | YES  |     | NULL    |                |
| tblCDefaults_DeductionIreland_High            | double       | YES  |     | NULL    |                |
| tblCDefaults_DeductionIreland_Low             | double       | YES  |     | NULL    |                |
| tblcdefaults_markupMaterials                  | double       | YES  |     | NULL    |                |
| tblcdefaults_markupLabour                     | double       | YES  |     | NULL    |                |
| tblcdefaults_markupSubMaterials               | double       | YES  |     | NULL    |                |
| tblcdefaults_markupSubLabour                  | double       | YES  |     | NULL    |                |
| tblcdefaults_markupStock                      | double       | YES  |     | NULL    |                |
| tblcdefaults_isDisableForeignCurrencyPosting  | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_IsUseManualInvNos                | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsPOstOrdNoToExRefApp            | tinyint(4)   |      |     | 0       |                |
| tblCDefaults_IsPOstExRefToSageCustomerOrderNo | tinyint(4)   |      |     | 0       |                |
| tblcdefaults_isNewCalendarActive              | tinyint(4)   | YES  |     | NULL    |                |
| tblcdefaults_isPlantEnabled                   | tinyint(4)   | YES  |     | NULL    |                |
| tblcdefaults_AttachedFilesPath                | longtext     | YES  |     | NULL    |                |
| tblCDefaults_isMaintenanceStatusesUpdated     | tinyint(4)   | YES  |     | NULL    |                |
| tblCDefaults_appointmentduewarninghours       | double       | YES  |     | NULL    |                |
| tblcdefaults_ispostorderno                    | tinyint(4)   |      |     | 0       |                |
| tblcdefaults_ispostappno                      | tinyint(4)   |      |     | 0       |                |
| tblcdefaults_ischecksagelogin                 | tinyint(4)   |      |     | 1       |                |
| tblCDefaults_unreceivedJobTimeout             | int(11)      | YES  |     | NULL    |                |
| tblcdefaults_isShowInsuranceExcess            | tinyint(4)   |      |     | 0       |                |
| tblcdefaults_isInvoiceMjobsSeperately         | tinyint(1)   |      |     | 0       |                |
| tblcdefaults_subscribername                   | varchar(50)  |      |     |         |                |
| tblcdefaults_isAllowCisMargin                 | int(11)      |      |     | 0       |                |
| tblcdefaults_isCalculateLabourFromMobile      | tinyint(4)   |      |     | 0       |                |
| tblcdefaults_isarchive                        | tinyint(4)   |      |     | 0       |                |
| tblcdefaults_isJobProgressIncludeApps         | tinyint(4)   |      |     | 0       |                |
| tblcdefaults_ispopunitprice                   | tinyint(4)   |      |     | 0       |                |
| tblcdefaults_devicecode                       | char(2)      | YES  |     |         |                |
| tblcdefaults_isshownewpopno                   | tinyint(4)   |      |     | -1      |                |
=end
