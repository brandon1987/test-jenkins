class AuditEvent < ActiveRecord::Base
  scope :created_quotes, -> { where(event_type: "quotes").where(description: "Created") }
end