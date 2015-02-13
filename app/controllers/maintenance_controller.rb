# encoding: UTF-8
include FormatHelper
include AmazonStorage
include GridData
include ReportDataHelper
include MjobHelper
include NotificationHelper
class MaintenanceController < ApplicationController


	def rendervisitxml
		render :partial =>"/partials/maintenance/maintenance_visit_customformcontents" , locals: {xmldata: params[:xmldata]}
	end

	def gridajaxdata
		#parameters:  draw, start,length,search,order,columns
		customfieldselect=[]
	    DesktopMaintenanceCustomField.order("tblMaintenanceCustomFields_ID DESC").all.each do |customfields| 	
			customfieldselect=customfieldselect.push ("CustomField"+ customfields.id.to_s)
		end

		#generic grid loading code
		maintenancefieldslist=['tblMaintenanceTask.tblMaintenanceTask_ID','tblMaintenanceTask.tblMaintenanceTask_Ref1','tblcontracts.tblContractXidJobNo','tblcustomers.tblCustomer_Ref','tblmaintenancetask.tblMaintenanceTask_WorkDescription','tblmaintenancecustomstatuses.tblMaintenanceCustomStatuses_StatusName','tblpriority.tblPriority_Ref','tblpriority.tblPriority_Description','tblmaintenancetask.tblMaintenanceTask_InceptionDateTime','tblmaintenancetask.tblMaintenanceTask_BeginDateTime','tblmaintenancetask.tblMaintenanceTask_PlannedCompletion','tblmaintenancetask.tblMaintenanceTask_CompletionDateTime','tbladdresses.tblAddresses_Name','tbladdresses.tblAddresses_Add1','tbladdresses.tblAddresses_Add2','tbladdresses.tblAddresses_Add3','tbladdresses.tblAddresses_Add4','tbladdresses.tblAddresses_Add5','tblmaintenancetask.tblMaintenanceTask_ManagerName','tbladdresses.tblAddresses_Description','tblmaintenancetask.tblMaintenanceTask_OrderValue','tbladdresses.tblAddresses_Ref'].concat(customfieldselect)
		strjoins="left join tblcontracts on tblContractId=tblMaintenanceTask_XIDContract left join tblcustomers on tblCustomer_Ref=tblMaintenanceTask_XIDCustomerRef left join tblmaintenancecustomstatuses on tblMaintenanceCustomStatuses_ID=tblMaintenanceTask_Status left join tblpriority on tblPriority_ID=tblMaintenanceTask_XIDPriority left join tbladdresses on tblAddresses_ID=tblMaintenanceTask_XIDSiteAddress"
		render :json => getGridData(DesktopMaintenanceTask,params,maintenancefieldslist,'tblMaintenanceTask_ID',strjoins,"",nil,[])
	end


	def loadsiteaddpopupcontents

		render :partial =>"/partials/popups/site_address_popup" ,locals:{:xidcontract => params[:xidcontract]}
	end

	def reloadlist
		#load the models and then rerender the list view
		loadlistitems
		render "_grid",:layout=>false
	end



	def loadlistitems
		#loads our maintenance list models from the current filter parameter
	    @maintenancecustomfield=DesktopMaintenanceCustomField.order("tblMaintenanceCustomFields_ID DESC").all		
		customfieldselect=[]
	    @maintenancecustomfield.each do |customfields| 
			customfieldselect=customfieldselect.push ("CustomField"+ customfields.id.to_s)
		end
		maintenancefieldslist=['tblMaintenanceTask.tblMaintenanceTask_ID','tblMaintenanceTask.tblMaintenanceTask_Ref1','tblcontracts.tblContractXidJobNo','tblcustomers.tblCustomer_Ref','tblmaintenancetask.tblMaintenanceTask_WorkDescription','tblmaintenancecustomstatuses.tblMaintenanceCustomStatuses_StatusName','tblpriority.tblPriority_Ref','tblpriority.tblPriority_Description','tblmaintenancetask.tblMaintenanceTask_InceptionDateTime','tblmaintenancetask.tblMaintenanceTask_BeginDateTime','tblmaintenancetask.tblMaintenanceTask_CompletionDateTime','tbladdresses.tblAddresses_Name','tbladdresses.tblAddresses_Add1','tbladdresses.tblAddresses_Add2','tbladdresses.tblAddresses_Add3','tbladdresses.tblAddresses_Add4','tbladdresses.tblAddresses_Add5','tblmaintenancetask.tblMaintenanceTask_ManagerName','tbladdresses.tblAddresses_Description','tblmaintenancetask.tblMaintenanceTask_OrderValue','tbladdresses.tblAddresses_Ref'].concat(customfieldselect)
		#loaded an array of field names for use in the select statement (including the customfields)
	    @completion=" tblMaintenanceTask_Status not in (5,6)" if (params[:completed]=="hide"||params[:completed]==nil)
	    @maintenance = DesktopMaintenanceTask.order("tblmaintenancetask_id DESC").joins("left join tblcontracts on tblContractId=tblMaintenanceTask_XIDContract left join tblcustomers on tblCustomer_Ref=tblMaintenanceTask_XIDCustomerRef left join tblmaintenancecustomstatuses on tblMaintenanceCustomStatuses_ID=tblMaintenanceTask_Status left join tblpriority on tblPriority_ID=tblMaintenanceTask_XIDPriority left join tbladdresses on tblAddresses_ID=tblMaintenanceTask_XIDSiteAddress").select(*maintenancefieldslist).where(@completion)
	    #because we want to use a set field list to speed up the queries we have to manually set the joins we want to use in this case.
	    #apparently .includes doesn't behave well with the .select argument
	end


	def new
		@disablemjobrefbox=false
		@maintenancetask = DesktopMaintenanceTask.new

		taskdefaults = DesktopDefault.select("tblCDefaults_MaintenanceMaterialMarkup,tblCDefaults_MaintenanceLabourMarkup,tblCDefaults_MaintenanceSubMarkup,tblCDefaults_MaintenanceStockMarkup,tblCDefaults_MaintenancePOMarkup,tblCDefaults_isMaintenanceAutoNumber").first
		@maintenancetask.labour_markup                   	= taskdefaults.tblCDefaults_MaintenanceLabourMarkup
		@maintenancetask.material_markup                 	= taskdefaults.tblCDefaults_MaintenanceSubMarkup
		@maintenancetask.sub_markup                      	= taskdefaults.tblCDefaults_MaintenanceSubMarkup
		@maintenancetask.stock_markup                    	= taskdefaults.tblCDefaults_MaintenanceStockMarkup
		@maintenancetask.po_markup                       	= taskdefaults.tblCDefaults_MaintenancePOMarkup
		@maintenancetask.inception_datetime                 = Time.now		
		@maintenancetask.is_quote							= -1
		@maintenancetask.is_product_invoice					= 0

		@disablemjobrefbox=true if taskdefaults.tblCDefaults_isMaintenanceAutoNumber==-1
		DesktopMaintenanceCustomField.select("tblMaintenanceCustomFields_ID,tblMaintenanceCustomFields_DefaultValue").each do |customfield|
			@maintenancetask["CustomField"<<customfield.tblMaintenanceCustomFields_ID.to_s]=customfield.tblMaintenanceCustomFields_DefaultValue
		end
	end




	def index
				
		#load the list models and then save default cookies if needed.
		#loadlistitems don#t do this any more, do it through ajax load
	    #set the default visible columns cookie for the grid.
		cookies['mjob-table-columns']='{"ID":false,"MJob No":true,"Job No":true,"Customer":true,"Description":true,"Status":true,"Priority":false,"Priority Desc":false,"Inception":true,"Start":true,"Completion":false,"Address Name":true,"Address 1":false,"Address 2":false,"Address 3":false,"Address 4":false,"Address 5":false,"Manager Name":true,"Address Description":true,"Value":true,"Site Ref":true}' if cookies['mjob-table-columns'].nil?
		cookies['mjob-table-grid-settings']='{"hScroll":false}' if cookies['mjob-grid-settings'].nil?

	end



	def create
		visits=JSON.parse(params[:visits])
		reassignedvisits=JSON.parse(params[:reassignedvisits])		
		deletedvisits=JSON.parse(params[:deletedvisits])
		completingvisits=JSON.parse(params[:completingvisits])
	    fields = request.POST;
		fields.delete :visits	    
		fields.delete :deletedvisits
		fields.delete :reassignedvisits	    
		fields.delete :completingvisits   
	    fields['username']=session[:username]
		fields['ref_1']=getNextMJobNo("",fields['xid_contract'],fields['xid_site_address'])
	    @maintenancetask = DesktopMaintenanceTask.new(fields)
		@maintenancetask.xid_site_address                     = -1
		@maintenancetask.xid_created_from_repetition          = -1
		@maintenancetask.xid_contract                         = -1
		@maintenancetask.xid_customer_ref                     = ''
		@maintenancetask.xid_priority                         = -1
		@maintenancetask.status                               = -1
		@maintenancetask.xid_project_manager                  = -1
		@maintenancetask.xid_schedule                         = -1
		@maintenancetask.xid_customer_branch                  = -1
		@maintenancetask.inception_datetime                   = Time.now
		@maintenancetask.begin_datetime                       = "1899-12-30 00:00:00"
		@maintenancetask.completion_datetime                  = "1899-12-30 00:00:00"
		@maintenancetask.planned_completion_datetime          = "1899-12-30 00:00:00"
		@maintenancetask.datetimestamp                        = "1899-12-30 00:00:00"
		@maintenancetask.ref_1                                = ''
		@maintenancetask.ref_2                                = ''
		@maintenancetask.ref_3                                = ''
		@maintenancetask.long_description                     = ''
		@maintenancetask.work_description                     = ''
		@maintenancetask.order_value                          = 0
		@maintenancetask.manager_name                         = ''
		@maintenancetask.schedule_name                        = ''
		@maintenancetask.username                             = ''
		@maintenancetask.work_carried_out                     = ''
		@maintenancetask.is_quote                             = -1
		@maintenancetask.is_schedule                          = 0
		@maintenancetask.is_product_invoice                   = 0
		@maintenancetask.progress_percentage                  = 0
		taskdefaults = DesktopDefault.select("tblCDefaults_MaintenanceMaterialMarkup,tblCDefaults_MaintenanceLabourMarkup,tblCDefaults_MaintenanceSubMarkup,tblCDefaults_MaintenanceStockMarkup,tblCDefaults_MaintenancePOMarkup").first
		@maintenancetask.labour_markup                   	= taskdefaults.tblCDefaults_MaintenanceLabourMarkup
		@maintenancetask.material_markup                 	= taskdefaults.tblCDefaults_MaintenanceSubMarkup
		@maintenancetask.sub_markup                      	= taskdefaults.tblCDefaults_MaintenanceSubMarkup
		@maintenancetask.stock_markup                    	= taskdefaults.tblCDefaults_MaintenanceStockMarkup
		@maintenancetask.po_markup                       	= taskdefaults.tblCDefaults_MaintenancePOMarkup

		@maintenancetask.attributes=fields

		@maintenancetask.inception_datetime =Time.now if @maintenancetask.inception_datetime=="1899-12-30 00:00:00"

		DesktopMaintenanceCustomField.select("tblMaintenanceCustomFields_ID,tblMaintenanceCustomFields_DefaultValue").each do |customfield|
			@maintenancetask["CustomField"<<customfield.tblMaintenanceCustomFields_ID.to_s]=customfield.tblMaintenanceCustomFields_DefaultValue			
		end
		@maintenancetask.save(fields)

		reassignvisits(reassignedvisits,@maintenancetask.id,@maintenancetask.ref_1)
		appointmentsok=save_visits(visits,@maintenancetask.id,@maintenancetask.ref_1)	
		delete_visits(deletedvisits)  

		set_complete_visit_notifications(completingvisits)


  	    render :json => {:success => @maintenancetask.id!=-1,:appointmentsave=>appointmentsok, :id=>@maintenancetask.id,:ref_1=>@maintenancetask.ref_1}		

	end

	def set_complete_visit_notifications(visits)
		visits.each do |visit|
			visitrecord=DesktopMaintenanceVisit.find(visit)
			if visitrecord
				add_notification_internal("Maintenance Visit Completion","Maintenance Visit "<< visitrecord.integration_job_no<<" has been completed" ,"/maintenance/"<< visitrecord.xid_mjob.to_s)
			end
		end
	end


	def update
		visits=JSON.parse(params[:visits])
		deletedvisits=JSON.parse(params[:deletedvisits])
		reassignedvisits=JSON.parse(params[:reassignedvisits])
		completingvisits=JSON.parse(params[:completingvisits])		
		fields = request.POST;
		fields.delete :visits
		fields.delete :deletedvisits
		fields.delete :reassignedvisits
		fields.delete :completingvisits

	    fields['username']=session[:username]
	    @maintenancetask = DesktopMaintenanceTask.find(params[:id])
	    puts "FIELDS+======================"<<fields.to_s
		savesuccess=@maintenancetask.update(fields)	    
		reassignvisits(reassignedvisits,@maintenancetask.id,@maintenancetask.ref_1)
		appointmentsok=save_visits(visits,@maintenancetask.id,@maintenancetask.ref_1)
		delete_visits(deletedvisits)  

		set_complete_visit_notifications(completingvisits)

	    render :json => {:success => savesuccess ,:appointmentsave=>appointmentsok}

	end

	def show
		@maintenancetask = DesktopMaintenanceTask.find(params[:id])
	end
	def destroy
		visits=DesktopMaintenanceVisit.where(xid_mjob:params[:id])
		visits.each  do |visit|
	      DesktopIntegrationXML.destroy(visit.xid_xml) if visit.xid_xml!=-1
	      DesktopMaintenanceVisit.destroy(visit.id)
		end		
		appointments=DesktopScheduleAppointment.where(xid_mjob:params[:id])
		appointments.each do |appointment|
			appointment.destroy
		end
		DesktopMaintenanceTask.find(params[:id]).destroy
      	deleteAmazonFolder("maintenance/"+params[:id])		
    	render :json => {:status => 0}      	
	end




	def saveattachment()
		begin
			saveAmazonFile("maintenance/#{params[:id]}",params[:targetfolder] + "/"+ params[:userfile].original_filename ,params[:userfile].read)
			render :json => {:success => true,:uploadno => params[:uploadno]}
		rescue StandardError => msg
			render :json => {:success => false,:uploadno => params[:uploadno],:error => msg}
		end
	end

	def deleteattachment()
		begin
		   deleteAmazonFile("maintenance/#{params[:id]}",params[:filename])
			render :json => {:success => true, :filename => params[:filename]}
		rescue StandardError => msg
			render :json => {:success => false,:filename => params[:filename],:error => msg}
		end
	end

	def downloadattachment()
		filedata=getAmazonFile("maintenance/#{params[:id]}",params[:filename])
		send_data filedata ,:filename => params[:filename],:disposition => "attachment"
	end 


	def save_visits(visits,mjobid,mjobref)
		bAppointmentSave=true
		visits.each do |visit|

			if visit["id"]=="-1"
				maintenancevisit = DesktopMaintenanceVisit.new
				maintenancevisit.xid_xml,                        =-1
				maintenancevisit.xid_mjob,                       =-1
				maintenancevisit.integration_status,             =1
				maintenancevisit.localstatusname,                ="Not Sent"
				maintenancevisit.integration_job_no,             =""
				maintenancevisit.instructions,                   =""
				maintenancevisit.engineer_id,                    =""
				maintenancevisit.name,                           =""
				maintenancevisit.work_carried_out,               =""
				maintenancevisit.edit_index,                     =0
				maintenancevisit.visit_planned_start,            =0
				maintenancevisit.visit_planned_end,              =0
				maintenancevisit.visit_inception,                =0
				maintenancevisit.transmission_timestamp,         =0
				maintenancevisit.work_start,                     =0
				maintenancevisit.work_complete,                  =0
				maintenancevisit.travel_time,                    =0
				maintenancevisit.work_time,                      =0
				maintenancevisit.changes_for_integration,        =0
				maintenancevisit.integration_error,              =0
				maintenancevisit.integration_error_type,         =0
				maintenancevisit.awaiting_integration_reply,     =0
				maintenancevisit.work_done,                      =""
				maintenancevisit.special_instructions,           =""
				maintenancevisit.xml_lock,                       =0
				maintenancevisit.materials_used,                 =""
				maintenancevisit.engineer_departed,              =""
				maintenancevisit.engineer_arrived,               =""
				maintenancevisit.visit_completed,                =""

				#Init Complete, fill with some real values now.

				maintenancevisit.integration_job_no=generateNextVisitNo(visit["engineerid"],mjobid,mjobref)
				maintenancevisit.name=visit["name"]
				maintenancevisit.integration_status=visit["status"]
				maintenancevisit.instructions=visit["instructions"]				
				maintenancevisit.xid_mjob=mjobid
				maintenancevisit.engineer_id=visit["engineerid"]
				maintenancevisit.visit_planned_start=visit["plannedstart"]
				maintenancevisit.visit_planned_end=visit["plannedend"]
				maintenancevisit.work_start=visit["workstart"]
				maintenancevisit.work_complete=visit["workend"]
				maintenancevisit.resource_key=visit["resourcekey"]

				maintenancevisit.save 
				updateVisitXML(maintenancevisit.id)   


				if !folderExistsInS3("/maintenance/#{mjobid}/"<< maintenancevisit.integration_job_no)
					createAmazonFolder("/maintenance/#{mjobid}/"<< maintenancevisit.integration_job_no)
				end

				bappointmentSave=false if saveAppointment(maintenancevisit,visit["appointmentid"],visit["engineerid"],visit["appointmentstart"],visit["appointmentend"])==false


	    	else


	    		maintenancevisit=DesktopMaintenanceVisit.find(visit["id"])
				#maintenancevisit.integration_job_no=generateNextVisitNo(visit["engineerid"],mjobid,mjobref) if maintenancevisit.engineer_id!=visit["engineerid"]
				maintenancevisit.instructions=visit["instructions"]
				maintenancevisit.work_carried_out=visit["workcarriedout"]
				maintenancevisit.materials_used=visit["materialsused"]
				maintenancevisit.integration_status	=visit["status"]
				maintenancevisit.name=visit["name"]
				maintenancevisit.xid_mjob=mjobid
				maintenancevisit.engineer_id=visit["engineerid"]
				maintenancevisit.visit_planned_start=visit["plannedstart"]
				maintenancevisit.visit_planned_end=visit["plannedend"]
				maintenancevisit.work_start=visit["workstart"]
				maintenancevisit.work_complete=visit["workend"]
				maintenancevisit.resource_key=visit["resourcekey"]

				maintenancevisit.save

				bappointmentSave=false if saveAppointment(maintenancevisit,visit["appointmentid"],visit["engineerid"],visit["appointmentstart"],visit["appointmentend"])==false

	    	end		
		end
		return bAppointmentSave
	end

	def delete_visits(visits)
		visits.each  do |visitid|
	      visit=DesktopMaintenanceVisit.find(visitid)
	      DesktopIntegrationXML.destroy(visit.xid_xml) if visit.xid_xml!=-1
	      DesktopMaintenanceVisit.destroy(visit.id)

		end
	end









    def reassignvisits (visits,mjobid,mjobref)
    	visits.each do |reassigned_visit|
	        visit=DesktopMaintenanceVisit.find(reassigned_visit["id"])
		        visit.integration_job_no=visit.id.to_s  #by temporarily renaming the visit before reunumbering we make sure we don't accidentally increment the visit number when we don't need to.
		        visit.save
		        visit.integration_job_no=generateNextVisitNo(reassigned_visit["engineerid"],mjobid,mjobref) 

				visit.engineer_id=reassigned_visit["engineerid"] 
				visit.name=reassigned_visit["engineername"]
				visit.resource_key=visit["resourcekey"]

				visit.save
        end
    end

	def saveAppointment(visit,existingappointmentid,engineerid,appointmentstart,appointmentend)
		if appointmentstart!=0 && appointmentend!=0
			resource=""
			employee=DesktopEmployee.select(:tblEmployee_Reference).where("tblEmployee_EngineerID='#{engineerid}'").first
			resource=employee.tblEmployee_Reference if employee	
			employeecis=DesktopEmployeeCIS.select(:tblEmployeeCIS_Reference).where("tblEmployeeCIS_EngineerID='#{engineerid}'").first
			resource=employeecis.tblEmployeeCIS_Reference if employeecis
		
			if resource==""
				return false  ##could not identify the planner resource for whatever we are trying to create.
			else

				if checkPlannerClashes(existingappointmentid,appointmentstart,appointmentend,resource)==false	

					appointment=DesktopScheduleAppointment.new() if existingappointmentid==""
					appointment=DesktopScheduleAppointment.find(existingappointmentid) if existingappointmentid!=""

               		if appointment
						appointment.long_description=visit.instructions
						appointment.xid_mjob=visit.xid_mjob       
						appointment.xid_maintenance_related=visit.id
						appointment.xid_contract=@maintenancetask.xid_site_address      
						appointment.xid_site_address=@maintenancetask.xid_contract       
						appointment.start_time=appointmentstart             
						appointment.end_time=appointmentend              
						appointment.resource_key=visit.resource_key   
						appointment.created_by=session[:username] if existingappointmentid==""
						appointment.last_updated_by=session[:username]        
						appointment.xid_plant=-1              
						appointment.save
					end
					return true #success state
				else
					return false
				end
			end
		else
			return true #no appointment to save so no problem son!
		end
	end

	def checkPlannerClashes(exclusionid,starttime,endtime,resource)
		appointments=DesktopScheduleAppointment.where(["tblMaintenanceScheduleAppointments_ID!=? AND tblMaintenanceScheduleAppointments_ResourceKey=? AND ((tblMaintenanceScheduleAppointments_StartTime>? and tblMaintenanceScheduleAppointments_StartTime<?)OR(tblMaintenanceScheduleAppointments_EndTime>? AND tblMaintenanceScheduleAppointments_EndTime<?))", exclusionid ,resource ,starttime,endtime,starttime,endtime ])
		if appointments.count==0
			return false
		else
			return true
		end
	end




	def addattachmentfolder
		if folderExistsInS3("maintenance/#{params[:id]}/"<< params[:folder])
			render :text=>"A folder with that name already exists. Please pick another and try again." 
		else
			if createAmazonFolder("/maintenance/#{params[:id]}"<< params[:folder])
				render :text=>"ok" 
			else
				render :text=>"There was an error creating the folder" 

			end
		end

	end

	def deleteattachmentfolder
		deleteAmazonFolder("/maintenance/#{params[:id]}"<< params[:folder]<<"/")
		render :text=>"ok" 		
	end

	def renameattachmentfolder
		renameAmazonFolder("/maintenance/#{params[:id]}"<< params[:folder]<<"","/maintenance/#{params[:id]}"<< params[:newfolder]<<"")
		render :text=>"ok"
	end

end
