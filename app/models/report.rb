class Report < ActiveRecord::Base
  self.primary_key = :filename

  def make_default
    Report.where(:is_default => true).update_all(:is_default => false)
    self.is_default = true
    self.save
  end

  def self.default_report
    Report.where(:is_default => true).first
  end
end