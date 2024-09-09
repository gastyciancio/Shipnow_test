class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }

  def stock_in_storage
    Stock.find_by(product: product, storage: order.storage).quantity || 0
  end
end
