class Clientportal::PortalMaintenanceVisitController < ClientportalController
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

      fieldslist=['tblMaintenanceRelated_Name','tblMaintenanceTask_Ref1','tblMaintenanceRelated_IntegrationJobNo','tblAddresses_Name','tblAddresses_Add5','tblIntegrationStatus_StatusName','1 as warning','tblMaintenanceRelated_transmissiontimestamp','tblMaintenanceRelated_VisitInception','tblMaintenanceRelated_VisitPlannedStart','tblMaintenanceRelated_VisitPlannedEnd','tblMaintenanceRelated_VisitCompleted','tblMaintenanceCustomStatuses_StatusName','tblMaintenanceRelated_Instructions','tblMaintenanceRelated_WorkCarriedOut'].concat(customfieldselect)
      
      forbiddencolumns=ClientportalHiddenColumns.where(:customer_id=>session[:customer_id],:section=>"is_portal_maintenance").pluck(:column_selector)
      puts "before filter-----------------------" << fieldslist.to_s
      fieldslist-=forbiddencolumns

      puts "after filter-------------------------" << forbiddencolumns.to_s

      strjoins="left join tblmaintenancetask on tblMaintenanceTask_ID=tblMaintenanceRelated_XIDMJob left join  tblmaintenancecustomstatuses on tblMaintenanceCustomStatuses_ID=tblMaintenanceTask_Status left join tblintegrationstatus on tblIntegrationStatus_StatusValue=tblMaintenanceRelated_IntegrationStatus left join tbladdresses on tblAddresses_ID=tblMaintenanceTask_XIDSiteAddress"
      render :json => getGridData(DesktopMaintenanceVisit,params,fieldslist,'tblMaintenanceRelated_ID',strjoins,"tblMaintenanceTask_XIDCustomerRef='#{session[:remotecustomer_ref]}'",nil,[])
    end

end