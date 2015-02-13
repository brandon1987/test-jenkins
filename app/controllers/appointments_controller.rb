include PlannerHelper

class AppointmentsController < ApplicationController
  def get_list_json
    queries_object = request.POST["queryparam"]
    results_array = []

    queries_object.each_with_index do |row, idx|
      row = row[1]
      id                      = row["id"]
      xid_mjob                = row["xidmjob"]
      xid_maintenance_related = row["xidmaintenancerelated"]
      xid_site_address        = row["xidsiteaddress"]
      start_time              = row["starttime"]
      end_time                = row["endtime"]
      job_no                  = row["jobno"]
      resource_key            = row["resourcekey"]
      mjob_ref                = row["mjobref"]
      visit_ref               = row["visitref"]
      integration_status      = row["integrationstatus"]
      description             = row["description"]
      long_description        = row["longdescription"]
      status_text             = row["statustext"]
      optional_fields         = row["optionalfields"]
      table_name              = row["table"]
      where                   = row["where"]
      additional_where        = row["additionalwhere"]

      query  = "SELECT #{optional_fields} #{id} AS id, #{xid_mjob} AS xidmjob, "
      query << "#{xid_maintenance_related} AS xidmaintenancerelated, "
      query << "#{start_time} AS starttime, #{end_time} AS endtime, "
      query << "#{resource_key} AS resourcekey, #{mjob_ref} AS mjobref, "
      query << "#{job_no} AS jobno, #{visit_ref} AS visitref, "
      query << "#{long_description} AS longdescription, "
      query << "#{integration_status} AS integrationstatus, #{status_text} AS statustext "
      query << "from #{table_name} #{where} #{additional_where}"

      query_results = UserDatabaseRecord.connection.execute(query)

      query_results.each(:as => :hash) do |result|
        results_array << result
      end
    end

    render :json => results_array
  end

  def update_mjob
    begin
      appointment = DesktopScheduleAppointment.find(params["appointmentid"])
    rescue ActiveRecord::RecordNotFound => e
      render :json => { :success => false }
      return
    end

    appointment.long_description = params["longdescription"]
    appointment.last_updated_by  = session[:username]

    appointment.save

    DesktopMaintenanceVisit.where(
      :integration_job_no => params["visitref"]
    ).update_all({
      :tblMaintenanceRelated_Instructions       => params["longdescription"],
      :tblMaintenanceRelated_IntegrationStatus => params["status"]
    })

    save_new_plant_tran(params["plantdata"]) unless params["plantdata"] == ""

    render :json => { :success => true, :status => params["status"] }
  end


  def update_contract
    appointment = DesktopScheduleAppointment.find(params["appointmentid"])
    appointment.long_description = params["longdescription"]
    appointment.last_updated_by  = session[:username]
    appointment.xid_contract     = params["xidcontract"]

    appointment.save

    save_new_plant_tran(params["plantdata"]) unless params["plantdata"] == ""

    render :json => {:status => 0}
  end
end