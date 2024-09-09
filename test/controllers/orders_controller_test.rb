require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @storage = Storage.create(name: 'Main Storage')
    @product = Product.create(reference: 'P001', name: 'Product 1')
    @stock = Stock.create(product: @product, storage: @storage, quantity: 10)
    @order = @storage.orders.create(reference: 'ORD001')
  end

  test 'should get index' do
    get orders_url
    assert_response :success

    response_body = JSON.parse(response.body)
    assert_not_empty response_body
    assert_includes response_body.first.keys, 'reference'
    assert_includes response_body.first.keys, 'ready'
    assert_includes response_body.first.keys, 'ready_at'
    assert_includes response_body.first.keys, 'storage'
    assert_includes response_body.first.keys, 'order_items'
    assert_includes response_body.first['order_items'].first.keys, 'quantity'
    assert_includes response_body.first['order_items'].first.keys, 'product'
    assert_includes response_body.first['order_items'].first['product'].keys, 'reference'
    assert_includes response_body.first['order_items'].first['product'].keys, 'name'
  end

  test 'should create order' do
    assert_equal 1, @storage.orders.count
    post orders_url, params: { order: { reference: 'ORD002', storage_name: @storage.name, products: [{ reference: @product.reference, quantity: 2 }] } }
    assert_response :created
    assert_equal 'Order created successfully', JSON.parse(response.body)['message']
    assert_equal 2, @storage.orders.count
  end

  test 'should not create order with invalid storage' do
    post orders_url, params: { order: { reference: 'ORD003', storage_name: 'Invalid Storage', products: [{ reference: @product.reference, quantity: 2 }] } }
    assert_response :not_found
    assert_equal 'Storage not found', JSON.parse(response.body)['message']
  end

  test 'should mark order as ready' do
    @order.order_items.create(product: @product, quantity: 1)
    patch "/orders/#{@order.reference}/mark_as_ready"
    assert_response :ok
    assert_equal 'Order marked as ready successfully', JSON.parse(response.body)['message']
    assert @order.reload.ready
  end

  test 'should not mark order as ready with insufficient stock' do
    @order.order_items.create(product: @product, quantity: 20)
    patch "/orders/#{@order.reference}/mark_as_ready"
    assert_response :unprocessable_entity
    assert_equal 'Not enough stock to prepare the order', JSON.parse(response.body)['message']
    assert_not @order.reload.ready
  end

  test 'should not mark order as ready if already ready' do
    @order.update!(ready: true, ready_at: Time.current)
    patch "/orders/#{@order.reference}/mark_as_ready"
    assert_response :unprocessable_entity
    assert_equal 'Order already ready', JSON.parse(response.body)['message']
  end
end
