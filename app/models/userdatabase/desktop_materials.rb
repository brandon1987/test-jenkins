class DesktopMaterials < UserDatabaseRecord
  self.table_name = "tblmaterials"
  alias_attribute :id               	  		,:tblMaterials_ID
  alias_attribute :xid_contract					,:tblMaterials_XIDContract
  alias_attribute :xid_job						,:tblMaterials_XIDJob
  alias_attribute :xid_customer 				,:tblMaterials_XIDCustomer
  alias_attribute :xid_dayworks 				,:tblMaterials_XIDDayworks
  alias_attribute :xid_costcode 				,:tblMaterials_XIDCostCode
  alias_attribute :xid_tender 					,:tblMaterials_XIDTender
  alias_attribute :xid_po 						,:tblMaterials_XIDPO
  alias_attribute :xid_grn 						,:tblmaterials_XIDGRN
  alias_attribute :xid_poitem 					,:tblMaterials_XIDPOItem
  alias_attribute :xid_invoice_classification 	,:tblMaterials_XIDInvoiceClassification
  alias_attribute :xid_maintenancetask 			,:tblMaterials_XIDMaintenanceTask

  alias_attribute :type 						,:tblMaterials_Type #6=pi/7=pc 
  alias_attribute :tender_item 					,:tblMaterials_TenderItem
  alias_attribute :ncode 						,:tblMaterials_NCode
  alias_attribute :dept 						,:tblMaterials_Dept
  alias_attribute :net 							,:tblmaterials_net
  alias_attribute :qty 							,:tblMaterials_Qty
  alias_attribute :vat 							,:tblMaterials_vat
  alias_attribute :dw_uplift 					,:tblMaterials_DWUpLift
  alias_attribute :plant_uplift 				,:tblMaterials_PlantUpLift
  alias_attribute :atrail 						,:tblMaterials_ATrail
  alias_attribute :invoice_number 				,:tblMaterials_InvoiceNumber
  alias_attribute :allocate_wip 				,:tblMaterials_AllocateWIP
  alias_attribute :signn 						,:tblMaterials_SignN
  alias_attribute :grn_no 						,:tblmaterials_GRNno
  alias_attribute :qty_plant_received 			,:tblMaterials_qtyPlantReceived
  alias_attribute :plant_rate 					,:tblMaterials_plantrate
  alias_attribute :no_of_plant 					,:tblMaterials_NoOfPlant
  alias_attribute :unit_price_grn 				,:tblmaterials_UnitPriceGrn
  alias_attribute :po_no 						,:tblmaterials_PONo
  alias_attribute :tran_no 						,:tblmaterials_TranNo
  alias_attribute :atrail_rec 					,:tblMaterials_ATrailRec
  alias_attribute :maintenance_markup 			,:tblMaterials_MaintenanceMarkup
  alias_attribute :currency_code 				,:tblMaterials_CurrencyCode
  alias_attribute :euro_net 					,:tblMaterials_EuroNet
  alias_attribute :euro_vat 					,:tblMaterials_EuroVat


  alias_attribute :cost_code 					,:tblMaterials_CostCode
  alias_attribute :tender_ref 					,:tblMaterials_TenderRef
  alias_attribute :acc_ref 						,:tblMaterials_ActRef
  alias_attribute :date 						,:tblMaterials_Date
  alias_attribute :inv_ref 						,:tblMaterials_InvRef
  alias_attribute :ex_ref						,:tblMaterials_XRef
  alias_attribute :details 						,:tblMaterials_Details
  alias_attribute :taxcode 						,:tblMaterials_TaxCode
  alias_attribute :is_plant 					,:tblMaterials_IsPlant
  alias_attribute :markup 						,:tblMaterials_Markup
  alias_attribute :last_user 					,:tblMaterials_LastUser
  alias_attribute :datetimestamp 				,:tblMaterials_DateTimeStamp
  alias_attribute :cisversiondate				,:CISVersionDate
  alias_attribute :wip_backup 					,:tblMaterials_WIPBackup
  alias_attribute :costm 						,:tblMaterials_CostM
  alias_attribute :isproblemwithposting 		,:tblMaterials_IsProblemWithPosting
  alias_attribute :wip_date 					,:tblMaterials_WIPDate
  alias_attribute :idisputed 					,:tblmaterials_idisputed

#deprecated fields,
  alias_attribute :worktype 					,:tblMaterials_WorkType #0






















































  
end
