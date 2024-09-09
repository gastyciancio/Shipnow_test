require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = Product.create(reference: 'P001', name: 'Product 1')
  end

  test 'should be valid with valid attributes' do
    assert @product.valid?
  end

  test 'should not be valid without a reference' do
    @product.reference = nil
    assert_not @product.valid?
  end

  test 'should not be valid without a name' do
    @product.name = nil
    assert_not @product.valid?
  end

  test 'should have many order_items' do
    assert_respond_to @product, :order_items
  end

  test 'should have many stocks' do
    assert_respond_to @product, :stocks
  end
end
