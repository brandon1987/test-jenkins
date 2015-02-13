include DesktopContractTypeAliases

class DesktopContractType < UserDatabaseRecord
  alias_attribute :id,   :tblContractTypeID
  alias_attribute :name, :tblContractTypeName

  self.primary_key = "tblContractTypeID"
  self.table_name = "tblContractType"
end