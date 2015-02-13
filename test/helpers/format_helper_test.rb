require 'test_helper'

class FormatHelperTest < ActionView::TestCase
  test "money format nil should return blank" do
    assert money_format(nil) == ""
  end

  test "money format empty strong should return blank" do
    assert money_format("") == ""
  end
end
