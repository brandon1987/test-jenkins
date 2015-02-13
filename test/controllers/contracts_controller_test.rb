require 'test_helper'

class ContractsControllerTest < ActionController::TestCase
  def setup
    login
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get index spreadsheet" do
    get :index, :format => :xls
    assert_response :success
  end

  test "should get contract from quotes page" do
    get :new_contract_from_quote, id: quotes(:quote_1).id
    assert_response :success
  end

  test "add eligible subbies to contract" do
    post :add_all_eligible_subbies, id: DesktopContract.first.id
    assert_response :success
  end
end
