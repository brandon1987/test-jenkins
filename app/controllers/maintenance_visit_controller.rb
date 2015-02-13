include ReportDataHelper
include GridData

class MaintenanceVisitController < ApplicationController
  	def index
      @section_name_override = "Maintenance Visit List"
      cookies['mjob-visit-table-columns']='{"Engineer":true,"MJob":false,"Visit Ref":true,"Address":true,"Post Code":true,"Visit Status":true,"Warning":true,"Received On Device":true,"Inception Date":true,"Planned Start":true,"Planned End":true,"Completion":true,"MJob Status":false,"Instructions":true,"Work Carried Out":true}' if cookies['mjob-visit-table-columns'].nil?
      cookies['mjob-visit-table-grid-settings']='{"hScroll":false}' if cookies['mjob-visit-table-grid-settings'].nil?
  	end


    def gridajaxdata
      #generic grid loading code
      fieldslist=['tblMaintenanceRelated_Name','tblMaintenanceTask_Ref1','tblMaintenanceRelated_IntegrationJobNo','tblAddresses_Name','tblAddresses_Add5','tblIntegrationStatus_StatusName','1 as warning','tblMaintenanceRelated_transmissiontimestamp','tblMaintenanceRelated_VisitInception','tblMaintenanceRelated_VisitPlannedStart','tblMaintenanceRelated_VisitPlannedEnd','tblMaintenanceRelated_VisitCompleted','tblMaintenanceCustomStatuses_StatusName','tblMaintenanceRelated_Instructions','tblMaintenanceRelated_WorkCarriedOut']
      strjoins="left join tblmaintenancetask on tblMaintenanceTask_ID=tblMaintenanceRelated_XIDMJob left join  tblmaintenancecustomstatuses on tblMaintenanceCustomStatuses_ID=tblMaintenanceTask_Status left join tblintegrationstatus on tblIntegrationStatus_StatusValue=tblMaintenanceRelated_IntegrationStatus left join tbladdresses on tblAddresses_ID=tblMaintenanceTask_XIDSiteAddress"
      render :json => getGridData(DesktopMaintenanceVisit,params,fieldslist,'tblMaintenanceRelated_ID',strjoins,"",nil,[])
    end
    

    def new
    end


    def create
      
    end


    def show
    end


    def edit
    end


    def update
    end


    def destroy
      visit=DesktopMaintenanceVisit.find(params[:id])
      DesktopIntegrationXML.destroy(visit.xid_xml) if visit.xid_xml!=-1
      DesktopMaintenanceVisit.destroy(visit.id)

      render :text =>"Success"
    end







    
    def loadvisitlist
      render :partial => 'partials/maintenance/maintenance_current_visits',:locals => { :xidmjob => params[:mjobid] } 
    end



    def setvisitvalues
       visit=DesktopMaintenanceVisit.find(params[:visitid])
       visit.integration_status=params[:statusvalue]
       visit.instructions=params[:visitinstructions]
       visit.work_carried_out=params[:visitworkcarriedout]
       visit.materials_used=params[:visitmaterialsused]
       visit.edit_index=Time.now.to_i
       visit.save
       render :text =>"Success"
    end

    def loadvisit
      @maintenancevisit = DesktopMaintenanceVisit.find(params[:id])   
      @resultarray = {:header=>"header here",:statuschanges=>render_to_string( :partial =>"/partials/maintenance/maintenance_visit_status_changes" ),
                      :customforms=>render_to_string( :partial =>"/partials/maintenance/maintenance_visit_customformlist" ),
                      :integration_status=>@maintenancevisit.integration_status,
                      :instructions=>@maintenancevisit.instructions,
                      :work_carried_out=>@maintenancevisit.work_carried_out,
                      :materials_used=>@maintenancevisit.materials_used
                     }
      render :text => @resultarray.to_json
    end


end

