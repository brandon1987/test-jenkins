include ReportDataHelper

module MjobHelper
	#moved these functions here so the mobile system can use them also
	def getNextMJobNo(value,xidcontract,xidsiteaddress)
		defaults=DesktopDefault.first
		return value if (!value.nil? && value!="") || defaults.tblCDefaults_isMaintenanceAutoNumber==0
		contract=DesktopContract.find(xidcontract)
		address=DesktopSiteAddress.find(xidsiteaddress)

		patterns=DesktopMaintenanceJobnoPatterns.where(jobdefault:-1).first
		existingjobnos=DesktopMaintenanceTask.pluck("tblMaintenanceTask_Ref1")
		if !patterns.nil?
			patternchars=patterns.pattern.split(//)
			startno=patterns.startno.split(//)
			sanitisedstartno=""
			startno.each_with_index do|x,i|
				sanitisedstartno<<x if patternchars[i]=~/[&%]/               #get the startno without anything except for characters that can be incremented.
			end

			finaljobno=""
			until (!existingjobnos.include? finaljobno) && finaljobno!=""
				sanitisedstartno=sanitisedstartno.next                       #Increment the number by 1
				sanitisedstartnoarray=sanitisedstartno.split(//)
				i=0
				finaljobno=""
				patternchars.each do |x|
					finaljobno<<contract.job_no.to_s if x=="£"
					finaljobno<<"#{address.ref}".strip!.to_s if x=="$"
					if x=~ /[&%]/
						finaljobno<<sanitisedstartnoarray [i]
						i+=1
					end
					finaljobno<< x if x=~/[^£$&%]/       					 #reassemble the number with the constants and check to see if this number is not yet used. If it is, increment again.
				end
			end

			return finaljobno
		else
			return "patternerror"
		end
	end

    def generateNextVisitNo(engineerid,mjobid,mjobref)
      existingjobs=DesktopMaintenanceVisit.where("tblMaintenanceRelated_EngineerID = ? or tblMaintenanceRelated_XIDMJob = ?", engineerid, mjobid).pluck("tblMaintenanceRelated_IntegrationJobNo")
      finalvisitno=""
      counter=0
      until (!existingjobs.include? finalvisitno) && finalvisitno!=""
        counter+=1
        finalvisitno=""
        finalvisitno=mjobref+"-"+engineerid+"-"+counter.to_s
      end
      return finalvisitno 
    end

    def updateVisitXML(visitid)
      visit=DesktopMaintenanceVisit.find(visitid)


      xmltext="<?xml version='1.0'?><FORMS>"
      DesktopMaintenanceVisitXmlTemplates.all.each do |template|
        xmltext << template.templatexml.gsub("<?xml version='1.0' encoding='Windows-1252'?>","").strip()
      end
      xmltext <<"</FORMS>"  #we have read in the template xml here

      reportdata=getMaintenanceReportData(visit.xid_mjob,visitid)
      reportdata.each do |row|
        row.attributes.to_a.each do |name, value|
          xmltext=xmltext.gsub(/\[#{name}\]/,value.to_s.encode(:xml => :text)) #replace the xml placeholders with actual field data for the defaults.
        end
      end
      xmltext=xmltext.squish()

      if visit.xid_xml=-1
        xmlrecord=DesktopIntegrationXML.new
        xmlrecord.xml=xmltext
        xmlrecord.save
        visit.xid_xml=xmlrecord.id
        visit.save
      else
        xmlrecord=DesktopIntegrationXML.find(visit.xid_xml)
        xmlrecord.xml=xmltext
        xmlrecord.save        
      end

      return true #return true for victory!
    end    

end