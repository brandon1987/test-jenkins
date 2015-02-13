class AddRelatedIdToAudit < ActiveRecord::Migration
  def change
    add_column :audit_events, :related_id, :integer
  end
end
