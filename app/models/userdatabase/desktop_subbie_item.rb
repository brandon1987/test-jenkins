class DesktopSubbieItem < UserDatabaseRecord
  self.table_name = "tblsubbieitems"

  alias_attribute :id,          :tblSubbieItems_ID
  alias_attribute :cis_ref,     :tblSubbieItems_CisRef
  alias_attribute :template_id, :tblSubbieItems_XIDTemplate
end
