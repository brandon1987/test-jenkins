class RenameTypeInAudit < ActiveRecord::Migration
  def change
    if self.table_exists?("audit_events")
      remove_column :audit_events, :type
      add_column    :audit_events, :event_type, :string
    end
  end
end
