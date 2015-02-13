require 'test_helper'

class DesktopContractTest < ActiveSupport::TestCase
  test "get next job number" do
    job_no = DesktopContract.next_job_no
    assert job_no.class == String
  end

  test "creating a contract creates the related work" do
    assert_difference 'DesktopWork.count', 1 do
      DesktopContract.new.save
    end
  end

  test "get eligible subbies" do
    assert DesktopContract.first.get_eligible_subbies
  end

  test "creating a contract from a quote sets correct values" do
    quote = quotes(:quote_1)
    contract = DesktopContract.new_from_quote(quote)

    assert contract.value       == quote.net
    assert contract.description == quote.details
  end

  test "add eligible subbies to contract" do
    contract = DesktopContract.find(40) # This contract has only the default subbie
    contract.add_all_eligible_subbies

    assert contract.get_eligible_subbies.count == 0
  end
end
