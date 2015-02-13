class AddDescriptionColumnToAudits < ActiveRecord::Migration
  def change
    if self.table_exists?("audit_events")
      add_column :audit_events, :description, :string
    end
  end
end
