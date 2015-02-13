require 'test_helper'

class SageInteractorTest < ActiveSupport::TestCase
  test "test connection with valid url and correct password" do
    sage_interactor = SageInteractor.new("http://192.168.0.22:8081/", "derp")
    assert sage_interactor.test_connection
  end

  test "should get department data" do
    sage_interactor = SageInteractor.new("http://192.168.0.22:8081/", "derp")
    department_data = sage_interactor.get_department_data(1)
    assert department_data
  end

  test "should post customer" do
    sage_interactor = SageInteractor.new("http://192.168.0.22:8081/", "derp")
    customer = DesktopCustomer.first
    response = sage_interactor.upsert_customer(customer)
    assert response == "0"
  end

  test "should get next invoice number" do
    sage_interactor = SageInteractor.get_by_company_id(1)
    next_num = sage_interactor.get_next_invoice_number
    assert /\A[-+]?\d+\z/ === next_num
  end

  test "should get stock data" do
    sage_interactor = SageInteractor.new("http://192.168.0.22:8081/", "derp")
    stock_data = sage_interactor.get_all_stock_data
    assert stock_data.is_a? Hash
  end
end
