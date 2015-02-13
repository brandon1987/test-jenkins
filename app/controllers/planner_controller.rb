include PlannerHelper
include AppointmentHelper

class PlannerController < ApplicationController
  def index
    @help_link_extension = "planner.html"

    #@access_rights = UserAccessRight.where(user_id: session[:user_id])
    #                  .select(:calendar_add, :calendar_edit, :calendar_delete)
    #                  .first
  end

  def get_defaults
    render :json => DesktopDefault.all
  end

  def get_resources
    queries_object = request.POST["queryparam"]
    results_array = [[]]

    queries_object.each_with_index do |row, idx|
      row = row[1]
      resource_id   = row["resourceid"]
      resource_name = row["resourcename"]
      table_name    = row["table"]
      resource_type = row["resourcetype"]
      engineer_id   = row["engineerid"]
      where         = row["where"]

      query  = "SELECT #{resource_id} AS resourceid, #{resource_name} AS resourcename, "
      query << "'#{resource_type}' AS resourcetype , #{engineer_id} AS engineerid "
      query << "FROM #{table_name} #{where} order by #{resource_name}"
      results_array[idx] ||= []
      query_results = UserDatabaseRecord.connection.execute(query)
      query_results.each(:as => :hash) do |result|
        results_array[idx] << result
      end
    end

    render :text => results_array.to_json
  end

  def cost_code_list
    query  = "SELECT tblCostCode_Ref AS id, "
    query << "tblCostCode_Ref AS field1, tblCostCode_Description as field2, "
    query << "tblCostCode_Ref as textcombined from tblCostCodes"

    results_array = []

    query_results = UserDatabaseRecord.connection.execute(query)
    query_results.each(:as => :hash) do |result|
      results_array << result
    end

    render :json => results_array
  end

  def mjob_list
    render :json => get_mjob_list_for_dropdowns
  end

  def contract_list
    render :json => get_contract_list_for_dropdowns
  end

  def tenders_list
    contract = request.POST["tendercontract"]

    tenders = DesktopTender.select(
      "tblTender_ID",
      "tblTender_Ref as field1",
      "tblTender_Details as field2",
      "CONCAT(tblTender_Ref, ' ', tblTender_Details) as textcombined",
    ).where("tblTender_IsGroup = 0 AND tblTender_XIDContract = '#{contract}'")

    results = []
    tenders.each do |t|
      results << {
        :id           => t.tblTender_ID,
        :field1       => t.field1,
        :field2       => t.field2,
        :textcombined => t.textcombined
      }
    end

    render :json => results
  end

  def get_plant_code_details
    items = DesktopStock.where(:tblStock_StockCode => request.POST["stockcode"])
    render :json => items
  end

  def load_event_details
    appointment = DesktopScheduleAppointment.where(id: params[:appointmentid]).first

    render :json => { :success => false } and return if appointment.nil?

    job_no = appointment.desktop_maintenance_visit["tblMaintenanceRelated_IntegrationJobNo"] unless appointment.desktop_maintenance_visit.nil?
    integration_status = appointment.desktop_maintenance_visit["tblMaintenanceRelated_IntegrationStatus"] unless appointment.desktop_maintenance_visit.nil?
    result = {
      :success                                             => true,
      "tblMaintenanceScheduleAppointments_LongDescription" => appointment["tblMaintenanceScheduleAppointments_LongDescription"],
      "tblMaintenanceRelated_IntegrationJobNo"             => job_no,
      "tblMaintenanceScheduleAppointments_XIDMJob"         => appointment["tblMaintenanceScheduleAppointments_XIDMJob"],
      "tblMaintenanceScheduleAppointments_XIDContract"     => appointment["tblMaintenanceScheduleAppointments_XIDContract"],
      "tblMaintenanceRelated_IntegrationStatus"            => integration_status,
      "tblmaintenancescheduleappointments_XIDPlant"        => appointment["tblmaintenancescheduleappointments_XIDPlant"],
      "tblmaintenancescheduleappointments_CreatedBy"       => appointment["tblmaintenancescheduleappointments_CreatedBy"],
      "tblmaintenancescheduleappointments_LastUpdated"     => appointment["tblmaintenancescheduleappointments_LastUpdated"]
    }

    render :json => result
  end

  def load_plant_tran_details
    tran = DesktopStockTran.select(
      "tblStock_Details",
      "tblStock_Ref",
      "DATE_FORMAT(tblStock_DateTran,'%d-%m-%Y') as datetran",
      "tblStock_SalesPrice",
      "tblStock_Qty",
      "tblStock_CostCode",
      "tblStock_XIDTender",
      "tblStock_Description",
      "tblStock_XIDContract",
      "tblStockTran_XIDMaintenanceJob"
    ).find(request.POST["planttranid"])

    render :json => tran
  end

  def save_appointment
    rename                = request.POST["rename"]
    data_table            = request.POST["datatable"]
    id                    = request.POST["id"]
    id_field              = request.POST["idfield"]
    start_field           = request.POST["startfield"]
    end_field             = request.POST["endfield"]
    start_time            = request.POST["starttime"]
    end_time              = request.POST["endtime"]
    resource_key          = request.POST["resourcekey"]
    resource_field        = request.POST["resourcefield"]
    resource_name         = request.POST["resourcename"]
    original_resource_key = request.POST["originalresourcekey"]
    engineer_id           = request.POST["engineerid"]
      
    base_appointment   = DesktopScheduleAppointment.find(id)

    xid_mjob           = base_appointment.tblMaintenanceScheduleAppointments_XIDMJob
    mjob_no            = base_appointment.desktop_maintenance_task["tblMaintenanceTask_Ref1"] unless base_appointment.desktop_maintenance_task.nil?
    xid_related        = base_appointment.tblMaintenanceScheduleAppointments_XIDMaintenanceRelated
    long_description   = base_appointment.desktop_maintenance_visit["tblMaintenanceRelated_Instructions"] unless base_appointment.desktop_maintenance_visit.nil?
    integration_status = 1;
    visit_id           = -1
    visit_id           = base_appointment.desktop_maintenance_visit["tblMaintenanceRelated_ID"] unless base_appointment.desktop_maintenance_visit.nil?

    if rename == "true" and xid_mjob != -1
      visit_ref = next_job_reference(xid_mjob, mjob_no, engineer_id)

      # this is a maintenance appointment so cancel existing task,
      # make new task on correct employee and create new appointment
      old_task = DesktopMaintenanceVisit.find(xid_related)
      old_task.tblMaintenanceRelated_IntegrationStatus = 8
      old_task.save

      params = {
        :instructions        => long_description,
        :name                => resource_name,
        :xid_mjob            => xid_mjob,
        :integration_status  => integration_status,
        :integration_job_no  => visit_ref,
        :visit_planned_start => start_time,
        :visit_planned_end   => end_time,
        :engineer_id         => engineer_id,
        :edit_index          => Time.now.to_i.to_s,
        :xid_xml             => -1,
      }

      new_appointment = DesktopMaintenanceVisit.new(params)
      new_appointment.save

      visit_id = new_appointment.tblMaintenanceRelated_ID

      # generate the new form xml and save it to the records
      form_xml = generate_xml_for_visit(visit_id)
     
      integration_xml_record = DesktopIntegrationXML.new({
        :tblIntegrationXML_XML => form_xml
      })
      integration_xml_record.save

      xml_id = integration_xml_record.tblIntegrationXML_ID

      new_appointment.tblmaintenancerelated_XIDXML = xml_id
      new_appointment.save
      
      sql  = "UPDATE #{data_table} "
      sql << "SET #{start_field} = '#{start_time}', "
      sql << "#{end_field}       = '#{end_time}', "
      sql << "#{resource_field}  = '#{resource_key}', "
      sql << "tblMaintenanceScheduleAppointments_XIDMaintenanceRelated= #{visit_id}, "
      sql << "tblmaintenancescheduleappointments_LastUpdated='#{session[:username]}' "
      sql << "WHERE #{id_field}  =#{id}  ";
      UserDatabaseRecord.connection.execute(sql)
    else
      time_fields = ""
      time_fields << "#{start_field}=#{start_time}, " if start_time != "-1"
      time_fields << "#{end_field}=#{end_time}, "       if end_time   != "-1"

      sql  = "UPDATE #{data_table} "
      sql << "SET #{time_fields}"
      sql << "#{resource_field}='#{resource_key}', "
      sql << "tblmaintenancescheduleappointments_LastUpdated='#{session[:username]}' "
      sql << "WHERE #{id_field}=#{id}"

      UserDatabaseRecord.connection.execute(sql)

      if visit_id != -1
        sql  = "UPDATE tblMaintenanceRelated SET "
        sql << "tblMaintenanceRelated_Name='#{resource_name}' "
        sql << "WHERE tblMaintenanceRelated_id=#{visit_id}"
      end
      
      UserDatabaseRecord.connection.execute(sql)
    end

    if visit_id != -1
      time_fields = ""
      time_fields << "tblMaintenanceRelated_VisitPlannedStart=#{start_time}" if start_time != "-1"
      time_fields << ", " if start_time != "-1" and end_time != "-1"
      time_fields << "tblMaintenanceRelated_VisitPlannedEnd=#{end_time}"     if end_time   != "-1"
      time_fields << ", " if time_fields!=""
      time_fields << "tblMaintenanceRelated_EditIndex="<<Time.now.to_i.to_s 
      sql = "UPDATE tblmaintenancerelated SET #{time_fields} WHERE tblMaintenanceRelated_id=#{visit_id}"
      UserDatabaseRecord.connection.execute(sql)
    end

    render :json => request.POST
  end

  def save_new_appointment_contract
    plant_id = -1
    plant_data = request.POST["plantdata"]
    plant_id = save_new_plant_tran(plant_data) unless plant_data == ""

    params = {
      :tblMaintenanceScheduleAppointments_LongDescription       => request.POST["longdescription"],
      :tblMaintenanceScheduleAppointments_XIDMJob               => -1,
      :tblMaintenanceScheduleAppointments_XIDMaintenanceRelated => -1,
      :tblMaintenanceScheduleAppointments_XIDContract           => request.POST["xidcontract"],
      :tblMaintenanceScheduleAppointments_XIDSiteAddress        => -1,
      :tblMaintenanceScheduleAppointments_StartTime             => request.POST["starttime"],
      :tblMaintenanceScheduleAppointments_EndTime               => request.POST["endtime"],
      :tblMaintenanceScheduleAppointments_ResourceKey           => request.POST["resourcekey"],
      :tblmaintenancescheduleappointments_CreatedBy             => session[:username],
      :tblmaintenancescheduleappointments_LastUpdated           => session[:username],
      :tblmaintenancescheduleappointments_XIDPlant              => plant_id
    }

    success = DesktopScheduleAppointment.new(params).save

    return_value = success ? 0 : 1
    render :json => {:status => return_value}
  end

  # Create records for a brand new appointment of type mjob
  def save_new_appointment_mjob
    plant_id           = -1
    long_description   = request.POST["longdescription"]
    xid_contract       = request.POST["xidcontract"]
    start_time         = request.POST["starttime"]
    end_time           = request.POST["endtime"]
    resource_key       = request.POST["resourcekey"]
    visit_ref          = request.POST["visitref"]
    integration_status = request.POST["integrationstatus"]
    xid_site_address   = request.POST["xidsiteaddress"]
    xid_mjob           = request.POST["xidmjob"]
    engineer_id        = request.POST["engineerid"]
    resource_name      = request.POST["resourcename"]

    task = DesktopMaintenanceTask.find(xid_mjob)

    xid_site_address   = task.xid_site_address
    mjob_no            = task.ref_1
    plant_data         = request.POST["plantdata"]

    plant_id = save_new_plant_tran(plant_data) unless plant_data == ""

    # Resolve mjob autonumbering to give next available job number
    if visit_ref == "Autonumber"
      visit_ref = next_job_reference(xid_mjob, mjob_no, engineer_id)
    end

    # All parameters finalised, save the new job
    edit_index = Time.now.to_i.to_s
    new_task = DesktopMaintenanceVisit.new({
      :instructions        => long_description,
      :name                => resource_name,
      :xid_mjob            => xid_mjob,
      :integration_status  => integration_status,
      :integration_job_no  => visit_ref,
      :visit_planned_start => start_time,
      :visit_planned_end   => end_time,
      :engineer_id         => engineer_id,
      :xid_xml             => -1,
      :edit_index          => edit_index
    })

    new_task.save
    visit_id = new_task.id

    # //generate the new form xml and save it to the records
    form_xml = generate_xml_for_visit(visit_id)

    integration_xml_record = DesktopIntegrationXML.new({
      :xml => form_xml
    })
    integration_xml_record.save

    new_task.xid_xml = integration_xml_record.id
    new_task.save

    # XML form data is now saved, save the planner appointment record
    DesktopScheduleAppointment.new({
      :long_description        => long_description,
      :xid_mjob                => xid_mjob,
      :xid_maintenance_related => visit_id,
      :xid_contract            => xid_contract,
      :xid_site_address        => xid_site_address,
      :start_time              => start_time,
      :end_time                => end_time,
      :resource_key            => resource_key,
      :created_by              => session[:username],
      :last_updated_by         => session[:username],
      :xid_plant               => plant_id
    }).save

    render :json => {:status => 0}
  end

  def copy_appointment
    base_appointment = DesktopScheduleAppointment.find(request.POST["appointmentid"])

    new_appointment = base_appointment.dup

    new_appointment.tblMaintenanceScheduleAppointments_StartTime   = request.POST["timestart"]
    new_appointment.tblMaintenanceScheduleAppointments_EndTime     = request.POST["timeend"]
    new_appointment.tblMaintenanceScheduleAppointments_ResourceKey = request.POST["resource"]
    new_appointment.tblmaintenancescheduleappointments_CreatedBy   = session[:username]
    new_appointment.tblmaintenancescheduleappointments_LastUpdated = session[:username]

    render :json => {:status => new_appointment.save}
  end

  def delete_appointment
    success = DesktopScheduleAppointment.find(request.POST["appointmentid"]).destroy
    render :json => {:status => success ? 0 : 1}
  end
end