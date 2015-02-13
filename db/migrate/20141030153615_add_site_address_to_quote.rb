class AddSiteAddressToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :address_id, :integer, default: -1
  end
end
