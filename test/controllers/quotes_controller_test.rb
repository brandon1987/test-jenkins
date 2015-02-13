require 'test_helper'

class QuotesControllerTest < ActionController::TestCase
  def setup
    login
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new page" do
    get :new
    assert_response :success
  end

  test "should get index spreadsheet" do
    get :index, :format => :xls
    assert_response :success
  end

  test "should view quote" do
    @quote = Quote.first
    get(:show, {'id' => @quote.id})
    assert_response :success
  end

  test "should create quote" do
    post(:create, {
      details: 'This is a quote in which we do quotey things',
      body:    "\[\]"
      })

    assert_response :success
  end

  test "should attach quote to contract" do
    post(:attach_to_contract, {
      id: Quote.first.id,
      contract_id: 1
      })

    assert_response :success
  end
end
