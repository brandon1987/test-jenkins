module PlannerHelper
  # Given a valid date timestamp, return that stamp in the form shown. Given
  # any other input, return the current timestamp.
  def get_date_timestamp(date_timestamp)
    if string_matches_timestamp_format(date_timestamp)
      return Time.parse(date_timestamp).strftime("%Y-%m-%d 00:00:00")
    else
      return Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
  end

  def string_matches_timestamp_format(string)
    match = string =~ /^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}/
    match != nil
  end

  # Generates complete and filled in xml templates for the forms on a given
  # mjob visit. 
  # Returns the generated xml as a string.
  def generate_xml_for_visit(visit_id)
    custom_fields = ""

    # Fetch all custom field names and build a string to use in selecting the
    # data for the report
    DesktopMaintenanceCustomField.all.each do |custom_field|
      name = custom_field.name.downcase.gsub(" ","")
      custom_fields << "CustomField#{custom_field.id} AS '#{name}', "
    end

    # Build our 'result' source query
    sql  = "SELECT tblMaintenanceTask.*, "
    sql << "#{custom_fields}"
    sql << "tblAddresses.*, "
    sql << "tblcompany.*, "
    sql << "CONCAT(tblAddresses.tblAddresses_Add1,'\n',tblAddresses.tblAddresses_Add2,'\n',tblAddresses.tblAddresses_Add3,'\n' ,tblAddresses.tblAddresses_Add4) AS SiteAddressCombined, "
    sql << "CONCAT(tblAddresses.tblAddresses_Add1,', ',tblAddresses.tblAddresses_Add2,', ',tblAddresses.tblAddresses_Add3) AS SiteAddressCombined1,CONCAT(tblAddresses.tblAddresses_Add4,', ' ,tblAddresses.tblAddresses_Add5) AS SiteAddressCombined2, "
    sql << "tblCustomerS.*, "
    sql << "tblPriority.*, "
    sql << "tblContracts.*, "
    sql << "tblMaintenanceRelated.* "
    sql << "FROM ((((tblMaintenanceTask LEFT JOIN tblCustomerS ON tblMaintenanceTask.tblMaintenanceTask_XIDCustomerRef = tblCustomerS.tblCustomer_Ref) LEFT JOIN tblPriority ON tblMaintenanceTask.tblMaintenanceTask_XIDPriority = tblPriority.tblPriority_ID) LEFT JOIN tblAddresses ON tblMaintenanceTask.tblMaintenanceTask_XIDSiteAddress = tblAddresses.tblAddresses_ID) LEFT JOIN tblContracts ON tblMaintenanceTask.tblMaintenanceTask_XIDContract = tblContracts.tblContractId) LEFT JOIN tblMaintenanceRelated ON tblMaintenanceTask.tblMaintenanceTask_ID=tblMaintenanceRelated.tblMaintenanceRelated_XIDMJob ,tblcompany "
    sql << "WHERE tblMaintenanceRelated_ID=#{visit_id}";

    query_results = UserDatabaseRecord.connection.execute(sql)

    query_result, column_count, source_fields = nil, nil, nil

    query_results.each(:as => :hash) do |result|
      query_result = result
      column_count  = result.length
      source_fields = result.keys
    end

    str_forms = '<?xml version="1.0"?><FORMS>'

    # Load the forms source table and compile them into a stack of forms objects
    DesktopIntegrationForm.all.each do |form|
      xml = form.xml.sub("<?xml version='1.0' encoding='Windows-1252'?>", "")
      str_forms << xml
    end

    str_forms << '</FORMS>'

    # Loop through the field values we have and replace the placeholders with
    # the actual field data we want to send.
    (0..column_count).each do |idx|
      str_forms.sub!("[#{source_fields[idx]}]", ERB::Util.html_escape(query_result[source_fields[idx]]))
    end

    str_forms.gsub!(/\r\n/,'')
    str_forms.strip!

    return str_forms
  end

  def get_contract_list_for_dropdowns
    contracts = DesktopContract.select(
      "tblContractId",
      "tblContractXidJobNo AS field1",
      "tblContractDescription AS field2",
      "CONCAT(tblContractXidJobNo,' ',tblContractDescription) AS textcombined"
    ).where("tblContractStatus not in (2,3,4,0)").order("tblContractXidJobNo")

    results = []
    contracts.each do |c|
      results << {
        :id           => c.tblContractId,
        :field1       => c.field1,
        :field2       => c.field2,
        :textcombined => c.textcombined
      }
    end
    return results
  end

  def get_employee_list_for_dropdowns
    employees = DesktopEmployee.select(
      "tblemployee_Reference",
      "tblemployee_Surname AS field1",
      "tblemployee_FirstName AS field2",
      "CONCAT(tblemployee_FirstName,' ',tblemployee_Surname) AS textcombined"
    ).where("tblemployee_isLeaver=0 AND tblemployee_FirstName <> '<none>'")

    results = []
    employees.each do |e|
      results << {
        :id           => e.tblemployee_Reference,
        :field1       => e.field1,
        :field2       => e.field2,
        :textcombined => e.textcombined
      }
    end
    return results
  end

  def get_subbie_list_for_dropdowns
    subbies = DesktopSupplier.select(
      "tblSupplier_Ref",
      "tblSupplier_Ref as field1",
      "tblSupplier_Name as field2",
      "CONCAT(tblSupplier_Ref,' ',tblSupplier_Name) AS textcombined"
    ).where("tblSupplier_TaxTreatment <> ''")

    results = []
    subbies.each do |s|
      results << {
        :id           => s.tblSupplier_Ref,
        :field1       => s.field1,
        :field2       => s.field2,
        :textcombined => s.textcombined
      }
    end
    return results
  end

  def get_mjob_list_for_dropdowns
    mjobs = DesktopMaintenanceTask.select(
      "tblMaintenanceTask_ID",
      "tblMaintenanceTask_Ref1",
      "tblMaintenanceTask_WorkDescription",
      "CONCAT(tblMaintenanceTask_Ref1,' ',tblMaintenanceTask_WorkDescription) AS textcombined",
      "tblMaintenanceTask_XIDContract",
      "tblMaintenanceTask_XIDSiteAddress"
    ).where(
      "tblMaintenanceTask_Status not in (4,5,6)"
    ).order(
      "tblMaintenanceTask_Ref1"
    )#.includes(:desktop_contract) this is breaking stuff! Important to fix,
     # but disable until we can figure out why.
     # Horrible workaround to do basically the same thing but without the
     # breakage is in place

    contracts = DesktopContract.select(:id, :job_no)

    results = []

    return [] if mjobs.nil?
    
    mjobs.each do |m|
      related_contract = contracts.select { |contract| contract.id == m.xid_contract }.first
      results << {
        :id             => m.tblMaintenanceTask_ID,
        :field1         => m.tblMaintenanceTask_Ref1,
        :field2         => m.tblMaintenanceTask_WorkDescription,
        :textcombined   => m.textcombined,
        :XIDContract    => m.tblMaintenanceTask_XIDContract,
        :xidsiteaddress => m.tblMaintenanceTask_XIDSiteAddress,
        :jobno          => related_contract.job_no
      }
    end
    return results
  end

  def get_status_list_for_dropdowns
    statuses = DesktopIntegrationStatus.select(
      "tblIntegrationStatus_StatusValue",
      "tblIntegrationStatus_StatusName"
    )

    results =[]
    statuses.each do |s|
      results << {
        :id           => s.tblIntegrationStatus_StatusValue,
        :field1       => s.tblIntegrationStatus_StatusName,
        :field2       => '',
        :textcombined => s.tblIntegrationStatus_StatusName
      }
    end

    return results
  end

  def get_skills_list_for_dropdowns
    skills = DesktopSkill.select(
      "tblSkills_id",
      "tblSkills_Description"
    )

    results = []
    skills.each do |s|
      results << {
        :id           => s.tblSkills_id,
        :field1       => s.tblSkills_Description,
        :field2       => s.tblSkills_Description,
        :textcombined => s.tblSkills_Description
      }
    end

    return results
  end

  def save_new_plant_tran(plant_data)
    long_description = params["longdescription"]
    xid_contract     = params["xidcontract"]
    start_time       = params["starttime"]
    end_time         = params["endtime"]
    resource_key     = params["resourcekey"]

    plant_data["tender"] = -1 if plant_data["tender"] == 0

    params = {
      :tblStock_StockCode             => resource_key,
      :tblStock_ItemType              => 2,
      :tblStock_Details               => plant_data['details'],
      :tblStock_Ref                   => plant_data['ref'],
      :tblStock_DateTran              => get_date_timestamp(plant_data['date']),
      :tblStock_SalesPrice            => plant_data['price'],
      :tblStock_CostPrice             => plant_data['price'],
      :tblStock_Qty                   => plant_data['qty'],
      :tblStock_Job                   => plant_data['jobno'],
      :tblStock_XIDContract           => xid_contract,
      :tblStock_LastUser              => session[:username],
      :tblStock_DateTimeStamp         => get_date_timestamp("now"), #trick the date format into giving us a current time.
      :tblStock_CostCode              => plant_data['costcode'],
      :tblStock_XIDTender             => plant_data['tender'],
      :tblStock_Description           => plant_data['plantdescription'],
      :tblStock_TenderRef             => plant_data['tenderref'],
      :tblStockTran_XIDMaintenanceJob => plant_data['mjobid'],
      :tblStockTran_MaintenanceMarkup => 0,
      :tblstock_salesmarkup           => 0,
      :tblstock_salespriceoriginal    => plant_data['price'],
      :tblStock_Account               => "",
      :tblStock_TenderItem            => 0,
      :tblStock_Dept                  => 0,
      :tblStock_NCode                 => "",
      :tblStock_XRef                  => "",
      :tblStockTran_AllocateWIP       => 0,
      :tblStockTran_WIPBackup         => 0,
      :tblStockTran_CostStk           => 0,
      :tblStockTran_WIPDate           => '1899-12-30 00:00:00',
      :tblStock_MarkUp                => 0
    }
    
    tran = DesktopStockTran.find_or_create_by(plant_data['planttranid'])
    tran.attributes=params
    tran.save

    return tran.tblStockTranID
  end

  def next_job_reference(xid_mjob, mjob_ref, engineer_id)
    visits = DesktopMaintenanceVisit.where(:xid_mjob => xid_mjob)

    visits = visits.map    { |i| i.integration_job_no }
    visits = visits.select { |i| i.start_with? "#{mjob_ref}-#{engineer_id}-" }
    visits = visits.map    { |i| i.split("-")[2].to_i }
    visits = visits.uniq.sort

    max = visits.max || 0

    id_candidates = (1..max+1).to_a - visits

    new_id = id_candidates[0]

    return "#{mjob_ref}-#{engineer_id}-#{new_id}"
  end
end
