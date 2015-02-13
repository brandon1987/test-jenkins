require 'test_helper'
require 'nokogiri'

include PlannerHelper

class PlannerHelperTest < ActionView::TestCase
  # Testing 'get_date_timestamp'.
  # If given a valid timestamp, should return the same timestamp, of the form:
  # Y-m-d 00:00:00

  # If given anything else, it should return the current date in the form:
  # Y-m-d H:M:S
  test "Timestamp with timestamp input" do
    now = Time.now.to_s
    date_segment = now[0..9]
    result = get_date_timestamp(now)
    assert result == "#{date_segment} 00:00:00", "Got: #{result}, Expected: #{date_segment} 00:00:00"
  end

  test "Timestamp with empty string" do
    result = get_date_timestamp("")
    assert string_matches_timestamp_format(result), "Got: #{result}"
  end

  test "Timestamp with nil input" do
    result = get_date_timestamp(nil)
    assert string_matches_timestamp_format(result), "Got: #{result}"
  end

  test "Timestamp with non-timestamp input" do
    result = get_date_timestamp("cxvxcvcx")
    assert string_matches_timestamp_format(result), "Got: #{result}"
  end

  # Testing 'generate_xml_for_visit'.
  test "XML with visit id 1" do
    xml = generate_xml_for_visit(1)
    assert Nokogiri::XML(xml).errors.empty?
  end
end