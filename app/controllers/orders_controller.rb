class OrdersController < ApplicationController
  before_action :find_storage, only: :create
  before_action :find_order, only: %i[mark_as_ready]

  def index
    orders = Order.includes(:storage, order_items: :product).all

    render json: orders.as_json(
      only: %i[reference ready ready_at],
      include: {
        storage: { only: [:name] },
        order_items: {
          only: [:quantity],
          include: {
            product: { only: %i[reference name] }
          },
          methods: [:stock_in_storage]
        }
      }
    )
  end

  def create
    return render json: { message: 'Storage not found' }, status: :not_found unless @storage
    return render json: { message: 'Quantities of products must be greaten than 0' }, status: :unprocessable_entity unless quantities_valid?

    unless Order.all_products_valid?(order_params[:products])
      return render json: { message: "Verify product's reference" },
                    status: :unprocessable_entity
    end

    order = @storage.orders.new(reference: order_params[:reference])

    if order.save
      order.create_order_items(order_params[:products])
      render json: { message: 'Order created successfully' }, status: :created, include: :order_items
    else
      render json: { message: order.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def mark_as_ready
    return render json: { message: 'Order not found' }, status: :not_found unless @order
    return render json: { message: 'Order already ready' }, status: :unprocessable_entity if @order.ready

    unless @order.can_prepare_order?
      return render json: { message: 'Not enough stock to prepare the order' },
                    status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      @order.update!(ready: true, ready_at: Time.current)
      @order.deduct_stock
    end

    render json: { message: 'Order marked as ready successfully' }, status: :ok
  end

  private

  def order_params
    params.require(:order).permit(:reference, :storage_name, products: %i[reference quantity])
  end

  def find_storage
    @storage = Storage.find_by(name: order_params[:storage_name])
  end

  def find_order
    @order = Order.find_by(reference: params[:reference])
  end

  def quantities_valid?
    order_params[:products].all? { |products| products[:quantity].to_i > 0 }
  end
end
