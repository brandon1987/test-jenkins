class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :company_id, :limit => 11
      t.datetime :created
      t.text :invite_code
      t.string :recipient
    end
  end
end