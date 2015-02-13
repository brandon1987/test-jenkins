class DesktopStock < UserDatabaseRecord
  self.table_name = "tblstock"

  alias_attribute :code,              :tblStock_StockCode
  alias_attribute :item_type,         :tblstock_itemtype
  alias_attribute :short_description, :tblstock_description
  alias_attribute :unit_cost,         :tblStock_SalesPrice
  alias_attribute :unit_type,         :tblstock_unitofsale
end
