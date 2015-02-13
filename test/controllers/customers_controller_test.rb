require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  test "should get customer index" do
    login

    get :index
    assert_response :success
  end

  test "should show new customer screen" do
    login

    get :new
    assert_response :success
  end

  test "should show customer" do
    login

    @customer = Customer.first
    get :show, id: @customer.id

    assert_response :success
  end

  test "should destroy customer not associated with quote" do
    login

    count = Customer.count

    customer_id = (Customer.pluck(:id) - Quote.pluck(:xid_customer)).first

    @customer = Customer.find(customer_id)
    delete :destroy, id: @customer.id

    assert_response :success
    assert Customer.count == count - 1
  end

  test "should not destroy customer associated with quote" do
    login

    count = Customer.count

    related_quote = Quote.where("xid_customer != -1").first
    @customer = related_quote.customer
    delete :destroy, id: @customer.id

    assert_response :success
    assert Customer.count == count
  end

  test "should create a customer" do
    login

    count = Customer.count

    post(:create, {
      name: 'Test Customer'
      })

    assert_response :success
    assert Customer.count == count + 1
  end

  test "should update a customer" do
    login

    @customer = Customer.first
    patch(:update, 
      id: @customer.id,
      name: "This customer has been updated"
      )

    assert_response :success

    @customer.reload
    assert @customer.name == "This customer has been updated", @customer.name
  end

  test "should get customer address" do
    login

    @customer = Customer.first

    get(:get_address, id: @customer.id)
    assert_response :success
  end
end
