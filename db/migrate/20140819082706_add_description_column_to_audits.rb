class AddDescriptionColumnToAudits < ActiveRecord::Migration
  def change
    add_column :audit_events, :description, :string
  end
end
