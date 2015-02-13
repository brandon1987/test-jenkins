class Phoneportal::MainController < PhoneportalController
	include BCrypt
	include MjobHelper
	include AmazonStorage
	include NotificationHelper
	require "base64"


  	skip_before_action :verify_authenticity_token ##prevents caching fucking up the auth token

	def main
		if params[:special]=="connect"
			execute_connect()
		else

			if logincheck

			#	if params[:qry].index("startbase64")
			#		#we have some attached encoded file, detach that first and then process
			#		fileattachment=Base64.decode64(params[:qry][params[:qry].index("startbase64")+11,params[:qry].index("endbase64")-(params[:qry].index("startbase64")+11)])
			#		params[:qry]=params[:qry][0..params[:qry].index("startbase64")-1]+params[:qry][params[:qry].index("endbase64")+9..-1]
			#	end

				specialmode=params[:special] 
				if params[:qry]
					specialmode="image" if params[:qry][0..18]=='QRYDATA{"filename":'
					specialmode="completionlabour" if params[:qry][0..20]=='QRYDATA{"travelling":'
					specialmode="jobcompletion" if params[:qry].starts_with?('QRYDATA{"jobcompletion":')

				end

				case specialmode
					when "jobcompletion"
						execute_jobcompletion()
					when "timestamp"
						execute_timestamp()
					when "submit"
						execute_submit()
					when "completionlabour"
						execute_completion_labour()
					when "image"
						execute_image()
					when "mjob"
						execute_mjob()
					when "duplicatevisit"
						execute_duplicate_visit()

					else
						execute_general_query()
				end
			else
				#failed login
				render :text=> "failed login"
			end

		end

	end
	

	def execute_connect
		reset_session	
		if logincheck
			render :text=>"#{Rails.env}#{session[:company_id]}"
		else
			render :text=>""
		end
	end

	def execute_image
		confirmdatatags()
		if params[:qry]!=""

			image=JSON.parse(params[:qry])
			#puts "image is"<<image.to_s
			#puts "filename"<< image["filename"]
			visit=DesktopMaintenanceVisit.select("tblMaintenanceRelated_XIDMJob").where("tblMaintenanceRelated_IntegrationJobNo=?",image["visitref"]).first
			if visit
				saveAmazonFile("maintenance/#{visit.tblMaintenanceRelated_XIDMJob}/#{image["visitref"]}",image["filename"].gsub("'", ""),Base64.decode64(image["imagedata"]))
			end

		end
		render :text=>"confirmed"
	end

	def execute_duplicate_visit
		#we are duplicating a visit so simply read in the employee details, and the details of the vist being copied and then generate a new record.
		employee=DesktopEmployee.select("CONCAT(tblEmployee_FirstName,' ',tblEmployee_Surname) AS name").where("tblEmployee_EngineerID='#{params[:engineerid]}'").first
		employee=DesktopEmployeeCIS.select("CONCAT(tblEmployeecis_FirstName,' ',tblEmployeecis_Surname) AS name ").where("tblEmployeecis_EngineerID='#{params[:engineerid]}'").first if !employee
		employee=DesktopSupplier.select("tblSupplier_Name as name").where("tblSupplier_Ref='#{params[:engineerid]}'").first if !employee
		visit=DesktopMaintenanceVisit.select("tblmaintenancetask.*,tblmaintenancerelated.*").joins("LEFT JOIN tblmaintenancetask ON tblMaintenanceRelated_XIDMJob=tblMaintenanceTask_ID").where("tblMaintenanceRelated_IntegrationJobNo='#{params[:visitref]}'").first

		newvisit=DesktopMaintenanceVisit.new

		if visit && employee
			newvisit.tblMaintenanceRelated_Instructions=params[:instructions]
			newvisit.tblMaintenanceRelated_WorkCarriedOut=''
			newvisit.tblMaintenanceRelated_Name=employee.name
			newvisit.tblMaintenanceRelated_Status='Allocated'
			newvisit.tblMaintenanceRelated_XIDMJob=visit.tblMaintenanceTask_ID
			newvisit.tblMaintenanceRelated_EngineerID=params[:engineerid]
			newvisit.tblMaintenanceRelated_IntegrationStatus=2
			newvisit.tblMaintenanceRelated_IntegrationJobNo=generateNextVisitNo(params[:engineerid],visit.tblMaintenanceTask_ID,visit.tblMaintenanceTask_Ref1)
			newvisit.tblMaintenanceRelated_ChangesForIntegration=0
			newvisit.tblMaintenanceRelated_AwaitingIntegrationReply=0
			newvisit.tblMaintenanceRelated_WorkDone=''
			newvisit.tblMaintenanceRelated_EditIndex=Time.now
			newvisit.tblMaintenanceRelated_VisitPlannedStart=0
			newvisit.tblMaintenanceRelated_VisitPlannedEnd=0
			newvisit.tblMaintenanceRelated_VisitInception=0
			newvisit.save
			updateVisitXML(visit.id)
			render :text=>"confirmed"
		else
			render :text=>""
		end
	end

	def execute_general_query
		begin
			output=""
			if params[:qry]!=""
				result=DesktopCustomer.connection.select_all(params[:qry])

				if result
					result.each do |resultline|
						output<<resultline.to_json 
						output<<"\n"
					end
				end
			end
		rescue
			output=""
		ensure
			render:text=>output
		end
	end

	def execute_mjob
		defaults= DesktopDefault.select("tblCDefaults_MaintenanceMaterialMarkup,tblCDefaults_MaintenanceLabourMarkup,tblCDefaults_MaintenanceSubMarkup,tblCDefaults_MaintenanceStockMarkup,tblCDefaults_MaintenancePOMarkup").first
		
		maintenancetask=DesktopMaintenanceTask.new
		maintenancetask.tblMaintenanceTask_XIDContract=params[:contractid]
        maintenancetask.tblMaintenanceTask_XIDSiteAddress=params[:siteaddressid]
        maintenancetask.tblMaintenanceTask_XIDCustomerRef=params[:customerid]
        maintenancetask.tblMaintenanceTask_XIDPriority=-1
        maintenancetask.tblMaintenanceTask_InceptionDateTime=Time.now
        maintenancetask.tblMaintenanceTask_LongDescription=''
        maintenancetask.tblMaintenanceTask_Ref1=getNextMJobNo(nil,params[:contractid],params[:siteaddressid])
        maintenancetask.tblMaintenanceTask_ProgressPercentage=0
        maintenancetask.tblMaintenanceTask_WorkDescription='Job Created from PDA by #{params[:engineerid]}'
        maintenancetask.tblMaintenanceTask_OrderValue=0
        maintenancetask.tblMaintenanceTask_IsQuote=0
        maintenancetask.tblMaintenanceTask_LabourMarkup=defaults.tblCDefaults_MaintenanceLabourMarkup
        maintenancetask.tblMaintenanceTask_MaterialMarkup=defaults.tblCDefaults_MaintenanceMaterialMarkup
        maintenancetask.tblMaintenanceTask_SubMarkup=defaults.tblCDefaults_MaintenanceSubMarkup
        maintenancetask.tblMaintenanceTask_XIDCreatedFromRepetition=-1
        maintenancetask.tblMaintenanceTask_Status=2
        maintenancetask.tblMaintenanceTask_StockMarkup=defaults.tblCDefaults_MaintenanceStockMarkup
        maintenancetask.tblMaintenanceTask_POMarkup=defaults.tblCDefaults_MaintenancePOMarkup
        maintenancetask.tblMaintenanceTask_WorkCarriedOut=''
        maintenancetask.tblMaintenanceTask_DateTimeStamp=Time.now
        maintenancetask.tblMaintenanceTask_UserName='PDA'
        maintenancetask.tblMaintenanceTask_XIDProjectManager=-1
        maintenancetask.tblMaintenanceTask_ManagerName=''
        maintenancetask.tblMaintenanceTask_isSchedule=0
        maintenancetask.tblMaintenanceTask_isProductInvoice=0
        maintenancetask.tblMaintenanceTask_BeginDateTime='1899-12-30 00:00:00'
        maintenancetask.tblMaintenanceTask_CompletionDateTime='1899-12-30 00:00:00'
        maintenancetask.tblMaintenanceTask_Ref2=''
        maintenancetask.tblMaintenanceTask_Ref3=''
        maintenancetask.tblMaintenanceTask_ScheduleName=''
        maintenancetask.tblMaintenanceTask_XIDSchedule=0
        maintenancetask.tblMaintenanceTask_XIDCustomerBranch=-1
        maintenancetask.save

        visitowner=DesktopEmployee.select("CONCAT(tblEmployee_FirstName,' ', tblEmployee_Surname) as name").where("tblEmployee_EngineerID='#{params[:engineerid]}'").first
        visitowner=DesktopEmployeeCIS.select("CONCAT(tblEmployeeCIS_FirstName,' ',tblEmployeeCIS_Surname) as name").where("tblEmployeeCIS_EngineerID='#{params[:engineerid]}'").first if !visitowner
        visitowner=DesktopSuppler.select("tblSupplier_Name as name").where("tblSupplier_Ref='#{params[:engineerid]}'").first if !visitowner

        visit=DesktopMaintenanceVisit.new
		visit.tblMaintenanceRelated_Instructions=params[:instructions]
		visit.tblMaintenanceRelated_WorkCarriedOut=""
		visit.tblMaintenanceRelated_Name=
		visit.tblMaintenanceRelated_Status='Allocated'
		visit.tblMaintenanceRelated_XIDMJob=maintenancetask.id
		visit.tblMaintenanceRelated_EngineerID=params[:engineerid]
		visit.tblMaintenanceRelated_IntegrationStatus=2
		visit.tblMaintenanceRelated_IntegrationJobNo=maintenancetask.tblMaintenanceTask_Ref1<<"-"<<params[:engineerid]<<"-1"
		visit.tblMaintenanceRelated_ChangesForIntegration=0
		visit.tblMaintenanceRelated_AwaitingIntegrationReply=0
		visit.tblMaintenanceRelated_WorkDone=''
		visit.tblMaintenanceRelated_EditIndex=Time.now.to_i
		visit.save

		updateVisitXML(visit.id)

		render :text=>"confirmed"
	end

	def execute_completion_labour
		confirmdatatags()
		if params[:qry]!=""
			arguments = JSON.parse(params[:qry])
			#work out some basic values from our parameters.
          	timetravelling=arguments["travelling"].to_d
            timeonsite=arguments["onsite"].to_d
            hourstravelling=timetravelling/60.to_d
            hoursonsite=timeonsite/60.to_d
            visitref=arguments[:job]
            defaults=DesktopDefault.select("tblcdefaults_isCalculateLabourFromMobile,tblCDefaults_StartDateWN").first
            #creating labour is optional so check this first.
            if defaults.tblcdefaults_isCalculateLabourFromMobile==-1
            	week=604800
            	defaultstart=defaults.tblCDefaults_StartDateWN

            	weekstart=defaultstart
            	weekno=1
        	
        		#work out which payroll week we are in, and what its start date is
            	while (weekstart+week).past? do
            		weekno+=1
            		weekstart+=week
            	end

            	#load records for the visit in question and find its relevan payrates (if it has none then fail out.)
            	visit=DesktopMaintenanceVisit.select("tblMaintenanceTask.*,tblMaintenanceRelated.*,tblContracts.*").joins("left join tblMaintenanceTask on tblMaintenanceRelated_XIDMJob=tblMaintenanceTask_ID left join tblContracts on tblContractId=tblMaintenanceTask_XIDContract").where("tblMaintenanceRelated_IntegrationJobNo='#{arguments['job']}'").first
            	if visit
	            	travelrate= DesktopEmployeeCIS.select("tblEmployeeCIS_Reference as empid,tblEmployeeCIS_EngineerID as engineerid,tblEmpPayRateCIS_XIDPayRate as payrateid,tblEmployeeCIS_Reference as rateemployeexid,tblEmpPayRateCIS_Description as ratedescription,tblEmpPayRateCIS_RateAmtCur as rateamountcur,tblEmpPayRateCIS_Factor as factor,tblEmpPayRateCIS_ChargeOutRate as chargeoutrate").joins("LEFT JOIN tblemppayratecis ON tblEmpPayRateCIS_XIDEmployee=tblEmployeeCIS_ID").where("tblEmployeeCIS_EngineerID=? AND tblEmpPayRateCIS_isTravellingRate=-1",visit.tblMaintenanceRelated_EngineerID).first;
	            	siterate=   DesktopEmployeeCIS.select("tblEmployeeCIS_Reference as empid,tblEmployeeCIS_EngineerID as engineerid,tblEmpPayRateCIS_XIDPayRate as payrateid,tblEmployeeCIS_Reference as rateemployeexid,tblEmpPayRateCIS_Description as ratedescription,tblEmpPayRateCIS_RateAmtCur as rateamountcur,tblEmpPayRateCIS_Factor as factor,tblEmpPayRateCIS_ChargeOutRate as chargeoutrate").joins("LEFT JOIN tblemppayratecis ON tblEmpPayRateCIS_XIDEmployee=tblEmployeeCIS_ID").where("tblEmployeeCIS_EngineerID=? AND tblEmpPayRateCIS_isOnSiteRate=-1",visit.tblMaintenanceRelated_EngineerID).first;
	                isnopayroll=-1
	                if !siterate#didn't find anytyhing when looking at non payroll employees so check to see if the payroll ones are any better...
						isnopayroll=-1;                	
		            	travelrate= DesktopEmployee.select("tblEmployee_Reference as empid,tblEmployee_EngineerID as engineerid,tblEmpPayRate_XIDPayRate as payrateid,tblEmployee_Reference as rateemployeexid,tblEmpPayRate_Description as ratedescription,tblEmpPayRate_RateAmtCur as rateamountcur,tblEmpPayRate_Factor as factor,tblEmpPayRate_ChargeOutRate as chargeoutrate").joins("LEFT JOIN tblemppayrate ON tblEmpPayRate_XIDEmployee=tblEmployee_Reference").where("tblEmployee_EngineerID=? AND tblEmpPayRate_isTravellingRate=-1",visit.tblMaintenanceRelated_EngineerID).first;
		            	siterate=   DesktopEmployee.select("tblEmployee_Reference as empid,tblEmployee_EngineerID as engineerid,tblEmpPayRate_XIDPayRate as payrateid,tblEmployee_Reference as rateemployeexid,tblEmpPayRate_Description as ratedescription,tblEmpPayRate_RateAmtCur as rateamountcur,tblEmpPayRate_Factor as factor,tblEmpPayRate_ChargeOutRate as chargeoutrate").joins("LEFT JOIN tblemppayrate ON tblEmpPayRate_XIDEmployee=tblEmployee_Reference").where("tblEmployee_EngineerID=? AND tblEmpPayRate_isOnSiteRate=-1",visit.tblMaintenanceRelated_EngineerID).first;
	                end
	                if siterate

		                #see if we have a timesheet in the current week for this employee, if not create a new one.
		                timesheets=DesktopTimesheet.where("tblTimeSheet_XIDEmployee=? AND tblTimeSheet_DateTS>=? AND tblTimeSheet_DateTS<?",travelrate.rateemployeexid,weekstart,weekstart+week).first;
		                if !timesheets
		                	timesheets=DesktopTimesheet.new
		                    timesheets.tblTimeSheet_XIDEmployee=travelrate.rateemployeexid
		                    timesheets.tblTimeSheet_DateTS=Time.now
		                    timesheets.tblTimeSheet_DatePostedPayroll='1899-12-30 00:00:00'
		                    timesheets.tblTimeSheet_TotalHrs=0
		                    timesheets.tblTimeSheet_TotalNett=0
		                    timesheets.tblTimeSheet_TotalGross=0
		                    timesheets.tblTimeSheet_isPostedPayroll=-1
		                    timesheets.tblTimeSheet_Details='Timesheet generated by Construction Manager Mobile app'
		                    timesheets.tblTimesheet_Ref=''
		                    timesheets.tblTimeSheet_LastUser='MOB'
		                    timesheets.tblTimeSheet_DateTimeStamp=Time.now
		                    timesheets.tblTimeSheet_XIDEmpPayment=-1
		                    timesheets.tblTimeSheet_NoPayroll=isnopayroll
		                    timesheets.tblTimesheet_ChargeOutTotal=0
		                    timesheets.tblTimesheet_CopyHeaderDate=0
							timesheets.save
		                end

						#destroy any existing hour lines from this mjob and recreate them
		                existinghours = DesktopHour.where("tblHours_XIDTimeSheet=? AND tblHours_xidvisitorigin=?",timesheets.id,visit.tblMaintenanceRelated_ID)
		                if existinghours 
		                	existinghours.each do |hour|
		                		DesktopHour.destroy(hour.id)
		                	end
		                end

		                #add a new travel time labour line
	                	travellingline=DesktopHour.new
		                travellingline.tblHoursXIDContract=visit.tblMaintenanceTask_XIDContract
		                travellingline.tblHoursType=0
		                travellingline.tblHoursCostCode=0
		                travellingline.tblHoursExRef=''
		                travellingline.tblHoursTenderItem=0
		                travellingline.tblHours=hourstravelling
		                travellingline.tblHoursDate=Time.now
		                travellingline.tblHoursWeekNumber=weekno
		                travellingline.tblHoursRate=travelrate.rateamountcur
		                travellingline.tblHoursCharged=hourstravelling*travelrate.rateamountcur
		                travellingline.tblHoursDept=0
		                travellingline.tblHoursNCode=0
		                travellingline.tblHoursDetails="Travel:#{visit.tblMaintenanceRelated_IntegrationJobNo} Start:#{visit.tblMaintenanceRelated_WorkStart-(timetravelling*60)} End:#{visit.tblMaintenanceRelated_WorkStart}"
		                travellingline.tblHoursTaxCode=0
		                travellingline.tblHoursVat=0
		                travellingline.tblHoursDayWorkUplift=0
		                travellingline.tblHoursXIDCustomer=visit.tblContractXIDCustomer
		                travellingline.tblHoursXIDJob=visit.tblContractXidJobNo
		                travellingline.tblHoursXIDPay=-1
		                travellingline.tblHoursXIDWorks=-1
		                travellingline.tblHoursXIDAuditTrial=-1
		                travellingline.tblHoursXIDDayworks=-1
		                travellingline.tblHoursXIDSI=-1
		                travellingline.tblHours_XIDCostCode=-1
		                travellingline.tblHours_Markup=0
		                travellingline.tblHours_LastUser='MOB'
		                travellingline.tblHours_DateTimeStamp=Time.now
		                travellingline.tblHours_XIDTender=-1
		                travellingline.tblHours_EmployeeId=travelrate.empid
		                travellingline.tblHours_PaymentRefID=travelrate.payrateid
		                travellingline.tblHours_PayFactor=travelrate.factor
		                travellingline.tblHours_IsPostedPayRoll=0
		                travellingline.tblHours_DatePostedPayRoll='1899-12-30 00:00:00'
		                travellingline.tblHours_XIDTimeSheet=timesheets.id
		                travellingline.tblHoursTenderRef=''
		                travellingline.tblHours_WIPDate='1899-12-30 00:00:00'
		                travellingline.tblHours_AllocateWIP=hourstravelling*travelrate.rateamountcur*travelrate.factor
		                travellingline.tblHours_RateDescription=travelrate.ratedescription
		                travellingline.tblHours_NoPayroll=isnopayroll
		                travellingline.tblHours_ChargeOutTotal=hourstravelling*travelrate.chargeoutrate
		                travellingline.tblHours_XIDMaintenanceTask=visit.tblMaintenanceTask_ID
		                travellingline.tblHours_MaintenanceMarkup=visit.tblMaintenanceTask_LabourMarkup
		                travellingline.tblHours_TempHighestChargeValue=0
		                travellingline.tblHours_CostL=0
		                travellingline.tblHours_XIDvisitorigin=visit.tblMaintenanceRelated_ID
		                travellingline.save

	                	onsiteline=DesktopHour.new
		                onsiteline.tblHoursXIDContract=visit.tblMaintenanceTask_XIDContract
		                onsiteline.tblHoursType=0
		                onsiteline.tblHoursCostCode=0
		                onsiteline.tblHoursExRef=''
		                onsiteline.tblHoursTenderItem=0
		                onsiteline.tblHours=hoursonsite
		                onsiteline.tblHoursDate=Time.now
		                onsiteline.tblHoursWeekNumber=weekno
		                onsiteline.tblHoursRate=siterate.rateamountcur
		                onsiteline.tblHoursCharged=hoursonsite*siterate.rateamountcur
		                onsiteline.tblHoursDept=0
		                onsiteline.tblHoursNCode=0
		                onsiteline.tblHoursDetails="Time on Site:#{visit.tblMaintenanceRelated_IntegrationJobNo} Start:#{visit.tblMaintenanceRelated_WorkStart-(timetravelling*60)} End:#{visit.tblMaintenanceRelated_WorkStart}"
		                onsiteline.tblHoursTaxCode=0
		                onsiteline.tblHoursVat=0
		                onsiteline.tblHoursDayWorkUplift=0
		                onsiteline.tblHoursXIDCustomer=visit.tblContractXIDCustomer
		                onsiteline.tblHoursXIDJob=visit.tblContractXidJobNo
		                onsiteline.tblHoursXIDPay=-1
		                onsiteline.tblHoursXIDWorks=-1
		                onsiteline.tblHoursXIDAuditTrial=-1
		                onsiteline.tblHoursXIDDayworks=-1
		                onsiteline.tblHoursXIDSI=-1
		                onsiteline.tblHours_XIDCostCode=-1
		                onsiteline.tblHours_Markup=0
		                onsiteline.tblHours_LastUser='MOB'
		                onsiteline.tblHours_DateTimeStamp=Time.now
		                onsiteline.tblHours_XIDTender=-1
		                onsiteline.tblHours_EmployeeId=siterate.empid
		                onsiteline.tblHours_PaymentRefID=siterate.payrateid
		                onsiteline.tblHours_PayFactor=siterate.factor
		                onsiteline.tblHours_IsPostedPayRoll=0
		                onsiteline.tblHours_DatePostedPayRoll='1899-12-30 00:00:00'
		                onsiteline.tblHours_XIDTimeSheet=timesheets.id
		                onsiteline.tblHoursTenderRef=''
		                onsiteline.tblHours_WIPDate='1899-12-30 00:00:00'
		                onsiteline.tblHours_AllocateWIP=hoursonsite*siterate.rateamountcur*siterate.factor
		                onsiteline.tblHours_RateDescription=siterate.ratedescription
		                onsiteline.tblHours_NoPayroll=isnopayroll
		                onsiteline.tblHours_ChargeOutTotal=hoursonsite*siterate.chargeoutrate
		                onsiteline.tblHours_XIDMaintenanceTask=visit.tblMaintenanceTask_ID
		                onsiteline.tblHours_MaintenanceMarkup=visit.tblMaintenanceTask_LabourMarkup
		                onsiteline.tblHours_TempHighestChargeValue=0
		                onsiteline.tblHours_CostL=0
		                onsiteline.tblHours_XIDvisitorigin=visit.tblMaintenanceRelated_ID
		                onsiteline.save

		                DesktopCustomer.connection.execute("update tbltimesheet set tblTimeSheet_TotalHrs=(SELECT sum(tblHours) from tblhours where  tblTimeSheet_ID=tblHours_XIDTimeSheet) where tblTimeSheet_ID=#{timesheets.id}")
		                DesktopCustomer.connection.execute("update tbltimesheet set tblTimeSheet_TotalNett=(SELECT sum(tblHoursCharged) from tblhours where  tblTimeSheet_ID=tblHours_XIDTimeSheet) where tblTimeSheet_ID=#{timesheets.id}")
		                DesktopCustomer.connection.execute("update tbltimesheet set tblTimeSheet_TotalGross=(SELECT sum(tblHoursCharged*tblHours_PayFactor) from tblhours where  tblTimeSheet_ID=tblHours_XIDTimeSheet) where tblTimeSheet_ID=#{timesheets.id}")
		                DesktopCustomer.connection.execute("update tbltimesheet set tblTimesheet_ChargeOutTotal=(SELECT sum(tblHours_ChargeOutTotal) from tblhours where  tblTimeSheet_ID=tblHours_XIDTimeSheet) where tblTimeSheet_ID=#{timesheets.id}")
		            end
	        	end
            end
			render :text=>"confirmed"
		else
			render :text=>""
		end
	end


	def execute_submit
		begin
			confirmdatatags()
			if params[:qry]!=""
				DesktopCustomer.connection.execute(params[:qry])
				output="confirmed"
			else
				output=""
			end
		rescue
			output=""
		ensure
			render :text=>output
		end

	end

	def execute_jobcompletion
		confirmdatatags()		
		arguments = JSON.parse(params[:qry])
      	jobno=arguments["jobcompletion"].to_s
      	jobrecord=DesktopMaintenanceVisit.find_by integration_job_no:jobno
      	if jobrecord
			add_notification_internal("Maintenance Visit Completion","Maintenance Visit "<< jobrecord.integration_job_no<<" has been completed" ,"/maintenance/"<< jobrecord.xid_mjob.to_s)      		
      	end
      	render :text=>"confirmed"
	end



	def confirmdatatags
		if params[:qry][0..6]=="QRYDATA" && params[:qry][-7..-1]=="QRYDATA"
			params[:qry]=params[:qry][7..-8]
			return true
		else
			params[:qry]=""
			return false
		end
	end


	def execute_timestamp
		records_array = DesktopCustomer.connection.execute(params[:qry])
		records_array.each do |record|
			render :text=>record[0]
		end
	end


	def logincheck
		if !session[:company_id].nil? && session[:username]==params["username"]
			return true
		end


		reset_session

		username = params["username"]
		password = params["auth"]

		@user = User.where("lower(username) = ?", username.downcase).first
		respond_to do |format|
		  if @user.nil?
		  	reset_session
		    return false

		  else
		    if @user.hash_new == BCrypt::Engine.hash_secret(password, @user.salt_new) then
		      puts "===================================NEW SESSION=========================================="
		      set_up_session
		      Apartment::Tenant.switch("conmag_#{session[:company_id]}")
		      return true
		    else
			  reset_session			    	
		      return false
		    end
		  end
		end



	end

end