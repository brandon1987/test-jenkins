class CreateAuditTrailTable < ActiveRecord::Migration
  def change
    create_table :audit_events do |t|
      t.string   "type"
      t.string   "user"
      t.datetime "date"
    end

    drop_table :audit_quotes
  end
end
