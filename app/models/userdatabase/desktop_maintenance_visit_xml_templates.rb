
class DesktopMaintenanceVisitXmlTemplates < UserDatabaseRecord
	self.table_name = "tblintegrationforms"

	alias_attribute :id			, :tblIntegrationForms_ID 	
	alias_attribute :name		, :tblIntegrationForms_Name	
	alias_attribute :timestamp	, :tblIntegrationForms_Timestamp			
	alias_attribute :templatexml, :tblIntegrationForms_XML	

end



