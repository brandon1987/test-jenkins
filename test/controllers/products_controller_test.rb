require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  test "should create a product" do
    product = stock_items(:test_product11)  
    assert product.save
  end
  
  test "should view product" do
    login

    product = StockItem.first

    get(:show, {'id' => product.id})
    assert_response :success
  end
  
  test "should update product" do
    login

    @product = StockItem.first

    patch :update, id: @product.id, post: {short_description: "test"}

    assert_response :success
    response_json = JSON.parse(@response.body)
    assert response_json["success"]
  end
  
  test "should destroy product" do
    login

    product = StockItem.first

    count = StockItem.count
    delete :destroy, {id: product.id}, {session: @request.session}

    assert_response :success
    assert StockItem.count == count - 1
  end
end
