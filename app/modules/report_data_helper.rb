module ReportDataHelper

    def getMaintenanceReportData(mjobids, visitids)
      fieldarray = Array.new
      joinsarray = Array.new
      strwhere=""
      DesktopMaintenanceCustomField.all.each do |customfield|
        fieldarray<<("CustomField" <<customfield.id.to_s << " AS " << customfield.name.gsub(/[^0-9a-zA-Z]/,""))
      end

      fieldarray<<"tblMaintenanceTask.*"
      fieldarray<<"tblAddresses.*"
      fieldarray<<"tblBranchAddressesCustomer.*"
      fieldarray<<"tblcompany.*"
      fieldarray<<"CONCAT(tblAddresses.tblAddresses_Add1,'\n',tblAddresses.tblAddresses_Add2,'\n',tblAddresses.tblAddresses_Add3,'\n' ,tblAddresses.tblAddresses_Add4) AS SiteAddressCombined "
      fieldarray<<"CONCAT(tblAddresses.tblAddresses_Add1,', ',tblAddresses.tblAddresses_Add2,', ',tblAddresses.tblAddresses_Add3) AS SiteAddressCombined1"
      fieldarray<<"CONCAT(tblAddresses.tblAddresses_Add4,', ' ,tblAddresses.tblAddresses_Add5) AS SiteAddressCombined2"
      fieldarray<<"tblCustomerS.*"
      fieldarray<<"tblPriority.*"
      fieldarray<<"tblContracts.*"

      joinsarray<<"LEFT JOIN tblCustomerS ON tblMaintenanceTask.tblMaintenanceTask_XIDCustomerRef = tblCustomerS.tblCustomer_Ref "
      joinsarray<<"LEFT JOIN tblPriority ON tblMaintenanceTask.tblMaintenanceTask_XIDPriority = tblPriority.tblPriority_ID  "
      joinsarray<<"LEFT JOIN tblAddresses ON tblMaintenanceTask.tblMaintenanceTask_XIDSiteAddress = tblAddresses.tblAddresses_ID "
      joinsarray<<"LEFT JOIN tblContracts ON tblMaintenanceTask.tblMaintenanceTask_XIDContract = tblContracts.tblContractId "
      joinsarray<<"LEFT JOIN tblBranchAddressesCustomer ON tblBranchAddressesCustomer_ID = tblMaintenanceTask_XIDCustomerBranch "
      joinsarray<<",tblcompany"

      strwhere<<"tblMaintenanceTask_ID IN (#{mjobids})"

      if visitids!=""
        fieldarray<<"tblMaintenanceRelated.*"
        fieldarray<<"FROM_UNIXTIME(tblMaintenanceRelated_WorkStart,'%d-%m-%Y %H:%i:%s') as visitWorkStart"
        fieldarray<<"FROM_UNIXTIME(tblMaintenanceRelated_WorkComplete,'%d-%m-%Y %H:%i:%s') as visitWorkComplete"
        fieldarray<<"FROM_UNIXTIME(tblMaintenanceRelated_VisitPlannedStart,'%d-%m-%Y %H:%i:%s') as visitPlannedStart"
        fieldarray<<"FROM_UNIXTIME(tblMaintenanceRelated_VisitPlannedEnd,'%d-%m-%Y %H:%i:%s') as visitPlannedEnd"
        fieldarray<<"tblsuppliers.*"

        joinsarray<<"LEFT JOIN tblMaintenanceRelated ON tblMaintenanceTask.tblMaintenanceTask_ID=tblMaintenanceRelated.tblMaintenanceRelated_XIDMJob"
        joinsarray<<"left join tblsuppliers on tblMaintenanceRelated_EngineerID=tblSupplier_Ref"

        strwhere<<" AND tblMaintenanceRelated_ID IN (#{visitids})"
      end

      results=DesktopMaintenanceTask.select(fieldarray).joins(joinsarray).where(strwhere)
      return results


#     sqlvisitsincludedfields= " , tblMaintenanceRelated.*,  FROM_UNIXTIME(tblMaintenanceRelated_WorkStart,'%d-%m-%Y %H:%i:%s') as visitWorkStart , FROM_UNIXTIME(tblMaintenanceRelated_WorkComplete,'%d-%m-%Y %H:%i:%s') as visitWorkComplete , FROM_UNIXTIME(tblMaintenanceRelated_VisitPlannedStart,'%d-%m-%Y %H:%i:%s') as visitPlannedStart, FROM_UNIXTIME(tblMaintenanceRelated_VisitPlannedEnd,'%d-%m-%Y %H:%i:%s') as visitPlannedEnd ,tblsuppliers.* " if visitids!=""
#     sqlvisitsincluded=" LEFT JOIN tblMaintenanceRelated ON tblMaintenanceTask.tblMaintenanceTask_ID=tblMaintenanceRelated.tblMaintenanceRelated_XIDMJob left join tblsuppliers on tblMaintenanceRelated_EngineerID=tblSupplier_Ref " if visitids!=""
#     sqlvisitwhere=" AND " 
#
#
#      strsql= "SELECT tblMaintenanceTask.*, #{customfields} tblAddresses.*,tblBranchAddressesCustomer.*,tblcompany.*, CONCAT(tblAddresses.tblAddresses_Add1,'\n',tblAddresses.tblAddresses_Add2,'\n',tblAddresses.tblAddresses_Add3,'\n' ,tblAddresses.tblAddresses_Add4) AS SiteAddressCombined ,CONCAT(tblAddresses.tblAddresses_Add1,', ',tblAddresses.tblAddresses_Add2,', ',tblAddresses.tblAddresses_Add3) AS SiteAddressCombined1 ,"
#      strsql << "CONCAT(tblAddresses.tblAddresses_Add4,', ' ,tblAddresses.tblAddresses_Add5) AS SiteAddressCombined2 , tblCustomerS.*, tblPriority.* ,tblContracts.* #{sqlvisitsincludedfields} FROM  tblMaintenanceTask  LEFT JOIN tblCustomerS    ON tblMaintenanceTask.tblMaintenanceTask_XIDCustomerRef = tblCustomerS.tblCustomer_Ref  LEFT JOIN tblPriority    ON tblMaintenanceTask.tblMaintenanceTask_XIDPriority = tblPriority.tblPriority_ID "
#      strsql << " LEFT JOIN tblAddresses    ON tblMaintenanceTask.tblMaintenanceTask_XIDSiteAddress = tblAddresses.tblAddresses_ID  LEFT JOIN tblContracts    ON tblMaintenanceTask.tblMaintenanceTask_XIDContract = tblContracts.tblContractId  left join tblBranchAddressesCustomer    on tblBranchAddressesCustomer_ID = tblMaintenanceTask_XIDCustomerBranch #{sqlvisitsincluded},  tblcompany  WHERE tblMaintenanceTask.tblMaintenanceTask_ID IN (#{mjobids}) #{sqlvisitwhere}"
#
#      return UserDatabaseRecord.connection.execute(strsql)
    end


end