class DesktopEmployee < UserDatabaseRecord
  self.table_name = "tblemployee"

  alias_attribute :ref, :tblEmployee_Reference
						 
  scope :project_managers, -> { where("tblEmployee_ProjectManager=-1") }

	def full_name
	  [tblEmployee_FirstName,tblEmployee_Surname].join(' ').html_safe
	end
end
