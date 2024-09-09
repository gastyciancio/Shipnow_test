class Order < ApplicationRecord
  belongs_to :storage
  has_many :order_items
  has_many :products, through: :order_items

  validates :reference, presence: true, uniqueness: true
  validates :storage, presence: true

  def self.all_products_valid?(products)
    products.all? { |product| Product.exists?(reference: product[:reference]) }
  end

  def create_order_items(products)
    products.each do |product_data|
      product = Product.find_by(reference: product_data[:reference])
      order_item = order_items.find_by(product: product)
      if order_item
        order_item.update(quantity: order_item.quantity + product_data[:quantity])
      else
        order_items.create(product: product, quantity: product_data[:quantity])
      end
      
    end
  end

  def can_prepare_order?
    order_items.all? do |order_item|
      stock = Stock.find_by(product: order_item.product, storage: storage)
      stock && stock.quantity >= order_item.quantity
    end
  end

  def deduct_stock
    order_items.each do |order_item|
      stock = Stock.find_by(product: order_item.product, storage: storage)
      stock.update!(quantity: stock.quantity - order_item.quantity)
    end
  end
end
