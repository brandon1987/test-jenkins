class Clientportal::PortalMaintenanceTaskController < ClientportalController
include GridData




	def index
   		@section_name_override =   "Maintenance Visit List"		
	end






    def gridajaxdata
      #generic grid loading code
      customfieldselect=[]
        DesktopMaintenanceCustomField.order("tblMaintenanceCustomFields_ID DESC").all.each do |customfields|  
        customfieldselect=customfieldselect.push ("CustomField"+ customfields.id.to_s)
      end

      fieldslist=['tblMaintenanceTask.tblMaintenanceTask_Ref1','tblcontracts.tblContractXidJobNo','tblcustomers.tblCustomer_Ref','tblmaintenancetask.tblMaintenanceTask_WorkDescription','tblmaintenancecustomstatuses.tblMaintenanceCustomStatuses_StatusName','tblpriority.tblPriority_Ref','tblpriority.tblPriority_Description','tblmaintenancetask.tblMaintenanceTask_InceptionDateTime','tblmaintenancetask.tblMaintenanceTask_BeginDateTime','tblmaintenancetask.tblMaintenanceTask_PlannedCompletion','tblmaintenancetask.tblMaintenanceTask_CompletionDateTime','tbladdresses.tblAddresses_Name','tbladdresses.tblAddresses_Add1','tbladdresses.tblAddresses_Add2','tbladdresses.tblAddresses_Add3','tbladdresses.tblAddresses_Add4','tbladdresses.tblAddresses_Add5','tblmaintenancetask.tblMaintenanceTask_ManagerName','tbladdresses.tblAddresses_Description','tblmaintenancetask.tblMaintenanceTask_OrderValue','tbladdresses.tblAddresses_Ref'].concat(customfieldselect)
      
      forbiddencolumns=ClientportalHiddenColumns.where(:customer_id=>session[:customer_id],:section=>"is_portal_maintenancetasks").pluck(:column_selector)

      fieldslist-=forbiddencolumns


      strjoins="left join tblcontracts on tblContractId=tblMaintenanceTask_XIDContract left join tblcustomers on tblCustomer_Ref=tblMaintenanceTask_XIDCustomerRef left join tblmaintenancecustomstatuses on tblMaintenanceCustomStatuses_ID=tblMaintenanceTask_Status left join tblpriority on tblPriority_ID=tblMaintenanceTask_XIDPriority left join tbladdresses on tblAddresses_ID=tblMaintenanceTask_XIDSiteAddress"
      render :json => getGridData(DesktopMaintenanceTask,params,fieldslist,'tblMaintenanceTask_ID',strjoins,"tblMaintenanceTask_XIDCustomerRef='#{session[:remotecustomer_ref]}'",nil,[])
    end

end