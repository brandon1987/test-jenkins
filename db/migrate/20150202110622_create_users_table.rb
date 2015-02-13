class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "username", limit: 100
      t.integer "xid_company"
      t.string "password_salt", limit: 10
      t.string "password_hash", limit: 60
      t.binary "connection_string"
      t.string "hash_new"
      t.string "salt_new"
      t.integer "priv_level"
    end
  end
end
