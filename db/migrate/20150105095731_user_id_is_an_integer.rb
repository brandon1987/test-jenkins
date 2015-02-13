class UserIdIsAnInteger < ActiveRecord::Migration
  def change
    change_column :user_access_rights, :user_id, :integer
  end
end
