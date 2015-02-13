class RenameTypeInAudit < ActiveRecord::Migration
  def change
    remove_column :audit_events, :type
    add_column    :audit_events, :event_type, :string
  end
end
