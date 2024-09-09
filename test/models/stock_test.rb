require "test_helper"

class StockTest < ActiveSupport::TestCase
  def setup
    @storage = Storage.create(name: 'Main Storage')
    @product = Product.create(reference: 'P001', name: 'Product 1')
    @stock = Stock.create(product: @product, storage: @storage, quantity: 10)
  end

  test 'should be valid with valid attributes' do
    assert @stock.valid?
  end

  test 'should not be valid without a product' do
    @stock.product = nil
    assert_not @stock.valid?
  end

  test 'should not be valid without a storage' do
    @stock.storage = nil
    assert_not @stock.valid?
  end

  test 'should not be valid without a quantity' do
    @stock.quantity = nil
    assert_not @stock.valid?
  end

  test 'should have a positive quantity' do
    @stock.quantity = -1
    assert_not @stock.valid?
    assert_includes @stock.errors[:quantity], "must be greater than or equal to 0"
  end

  test 'should return stock quantity for product and storage' do
    stock = Stock.find_by(product: @product, storage: @storage)
    assert_equal 10, stock.quantity
  end

  test 'should update quantity correctly' do
    @stock.update!(quantity: 20)
    assert_equal 20, @stock.reload.quantity
  end
end
