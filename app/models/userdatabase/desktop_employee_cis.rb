class DesktopEmployeeCIS < UserDatabaseRecord
  self.table_name = "tblemployeeCIS"

  alias_attribute :ref, :tblEmployeeCIS_Reference

  scope :project_managers, -> { where("tblEmployeeCIS_ProjectManager=-1") }

	def full_name
	  [tblEmployeeCIS_FirstName,tblEmployeeCIS_Surname].join(' ').html_safe
	end
end
