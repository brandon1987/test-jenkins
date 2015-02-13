class AddClientportalEmailAddress < ActiveRecord::Migration
  def change
    add_column :customers, :clientportal_email, :string, limit:255, default: ""
  end
end
