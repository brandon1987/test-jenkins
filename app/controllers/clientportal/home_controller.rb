class Clientportal::HomeController < ClientportalController
include FormatHelper
	
	def home
		@section_name_override="Clientportal Home"
	  	@customer=Customer.find(session[:customer_id])
	  	@company=Company.find(session[:company_id] )
	  	@latestmaintenancevisit= DesktopMaintenanceVisit.joins("left join tblMaintenanceTask on tblMaintenanceTask_ID=tblMaintenanceRelated_XIDMJob").where("tblMaintenanceTask_XIDCustomerRef=?",session[:remotecustomer_ref]).maximum(:edit_index)
	  	@totalvisitcount=DesktopMaintenanceVisit.joins("left join tblMaintenanceTask on tblMaintenanceTask_ID=tblMaintenanceRelated_XIDMJob").where("tblMaintenanceTask_XIDCustomerRef=?",session[:remotecustomer_ref]).count
	  	@activevisitcount=DesktopMaintenanceVisit.joins("left join tblMaintenanceTask on tblMaintenanceTask_ID=tblMaintenanceRelated_XIDMJob").where("tblMaintenanceTask_XIDCustomerRef=? and tblMaintenanceRelated_IntegrationStatus not in (4,8,9,10)",session[:remotecustomer_ref]).count


	  	@latestmaintenancetask= DesktopMaintenanceTask.where("tblMaintenanceTask_XIDCustomerRef=?",session[:remotecustomer_ref]).maximum("tblMaintenanceTask_DateTimeStamp")
	  	@totaltaskcount=DesktopMaintenanceTask.where("tblMaintenanceTask_XIDCustomerRef=?",session[:remotecustomer_ref]).count
	  	@activetaskcount=DesktopMaintenanceTask.where("tblMaintenanceTask_XIDCustomerRef=? and tblMaintenanceTask_Status not in (4,5,6,100000)",session[:remotecustomer_ref]).count
	

	end

end