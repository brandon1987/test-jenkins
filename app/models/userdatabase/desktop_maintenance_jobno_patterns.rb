class DesktopMaintenanceJobnoPatterns < UserDatabaseRecord
	self.table_name = "tbljobnopatternsmaintenance"
	alias_attribute :id,			 :tblJobNoPatternsMaintenance_ID	
	alias_attribute :name,			 :tblJobNoPatternsMaintenance_Name
	alias_attribute :pattern,		 :tblJobNoPatternsMaintenance_Pattern
	alias_attribute :jobdefault,	 :tblJobNoPatternsMaintenance_JobDefault
	alias_attribute :taskdefault,	 :tblJobNoPatternsMaintenance_TaskDefault
	alias_attribute :startno,		 :tblJobNoPatternsMaintenance_StartNo
end