class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :storage

  validates :quantity, :storage, :product, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
