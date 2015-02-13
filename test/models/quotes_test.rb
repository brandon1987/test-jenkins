require 'test_helper'

class QuotesTest < ActiveSupport::TestCase
  test "Assigning quote to contract increases contract value" do
    contract = DesktopContract.find(1)
    quote = quotes(:quote_1)

    old_value = contract.value

    assert_not old_value == quote.net

    quote.attach_to_contract(contract.id)

    contract.reload

    assert contract.value == old_value + quote.net, "#{contract.value} vs. #{old_value + quote.net}"
  end

  test "Moving quote away from contract decreases value" do
    quote = quotes(:quote_2)
    contract = DesktopContract.find(quote.xid_contract)

    old_value = contract.value
    quote_value = quote.value

    quote.attach_to_contract(1)

    contract.reload

    assert contract.value = old_value - quote_value
  end

  test "Quote reassignment should not reduce contract value below 0" do
    quote = quotes(:one_million_quote)
    contract = DesktopContract.find(quote.xid_contract)

    quote.attach_to_contract(1)
    contract.reload

    assert contract.value == 0
  end

  test "Invoice checks return proper values" do
    invoiced_quote = quotes(:invoiced_quote)
    assert     invoiced_quote.is_invoiced?
    assert_not invoiced_quote.part_invoiced?

    part_invoiced_quote = quotes(:part_invoiced_quote)
    assert_not part_invoiced_quote.is_invoiced?
    assert     part_invoiced_quote.part_invoiced?
  end

  test ".has_contract? returns proper values" do
    assert_not quotes(:quote_1).has_contract?
    assert     quotes(:quote_2).has_contract?
  end
end
