class RenameAccessRightsTable < ActiveRecord::Migration
  def change
    rename_table :access_rights, :user_access_rights
  end
end
