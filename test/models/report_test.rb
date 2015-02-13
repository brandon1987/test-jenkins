require 'test_helper'
 
class ReportTest < ActiveSupport::TestCase
  test "make report default" do
    current_default = Report.find_by(:is_default => true)
    assert_not current_default.nil?

    new_default = Report.where(:is_default => false).first

    new_default.make_default

    current_default.reload
    new_default.reload

    assert_not current_default.is_default
    assert     new_default.is_default
  end
end