class DesktopMemo < UserDatabaseRecord
  self.table_name = "tblmemo"

  alias_attribute :id,         :tblMemoID
  alias_attribute :details,    :tblMemoDetails
  alias_attribute :related_id, :tblMemoObjectXID
  alias_attribute :memo_type,  :tblMemoObject
end