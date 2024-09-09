require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  def setup
    @product = Product.create(reference: 'P001', name: 'Product 1')
    @storage = Storage.create(name: 'Main Storage')
    @order = @storage.orders.create(reference: 'ORD001')
    @order_item = @order.order_items.create(product: @product, quantity: 5)
    Stock.create(product: @product, storage: @storage, quantity: 10)
  end

  test 'should be valid with valid attributes' do
    assert @order_item.valid?
  end

  test 'should not be valid without an order' do
    @order_item.order = nil
    assert_not @order_item.valid?
  end

  test 'should not be valid without a product' do
    @order_item.product = nil
    assert_not @order_item.valid?
  end

  test 'should not be valid without a quantity' do
    @order_item.quantity = nil
    assert_not @order_item.valid?
  end

  test 'should calculate stock_in_storage' do
    assert_equal 10, @order_item.stock_in_storage
  end
end
