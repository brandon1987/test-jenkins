class AddExtraQuotesPerms < ActiveRecord::Migration
  def change
    add_column :user_access_rights, :quotes_order,   :boolean, default: true
    add_column :user_access_rights, :quotes_invoice, :boolean, default: true
    add_column :user_access_rights, :quotes_email,   :boolean, default: true
  end
end
