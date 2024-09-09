require "test_helper"

class OrderTest < ActiveSupport::TestCase
 def setup
    @storage = Storage.create(name: 'Main Storage')
    @product = Product.create(reference: 'P001', name: 'Product 1')
    @order = @storage.orders.create(reference: 'ORD001')
  end

  test 'should be valid with valid attributes' do
    assert @order.valid?
  end

  test 'should not be valid without a reference' do
    @order.reference = nil
    assert_not @order.valid?
  end

  test 'should not be valid without a storage' do
    @order.storage = nil
    assert_not @order.valid?
  end
end
