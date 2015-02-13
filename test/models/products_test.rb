require 'test_helper'
 
class ProductsTest < ActiveSupport::TestCase
  test "Cannot make duplicate records" do
    assert_raises(ActiveRecord::RecordNotUnique) do
      2.times do
        StockItem.new({:code => "duplicate"}).save
      end
    end
  end

  test "Update existing product" do
    product = stock_items(:test_product11)
    product.unit_cost = 1337
    assert product.save
  end

  test "Destroy product" do
    product = StockItem.find(stock_items(:test_product11))
    product.destroy

    assert_raises(ActiveRecord::RecordNotFound) do
      StockItem.find(product.code)
    end
  end
end