class AddRelatedIdToAudit < ActiveRecord::Migration
  def change
    if self.table_exists?("audit_events")
      add_column :audit_events, :related_id, :integer
    end
  end
end
