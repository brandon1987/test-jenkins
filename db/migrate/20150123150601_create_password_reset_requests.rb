class CreatePasswordResetRequests < ActiveRecord::Migration
  def change
    create_table :password_reset_requests do |t|
      t.text :username
      t.text :token
      t.datetime :created
    end
  end
end