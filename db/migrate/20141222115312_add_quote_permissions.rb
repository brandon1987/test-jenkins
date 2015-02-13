class AddQuotePermissions < ActiveRecord::Migration
  def change
    if self.table_exists?("user_access_rights")
      add_column :user_access_rights, :quotes_add,    :boolean, default: true
      add_column :user_access_rights, :quotes_edit,   :boolean, default: true
      add_column :user_access_rights, :quotes_delete, :boolean, default: true
    end
  end
end
