class Product < ApplicationRecord
  has_many :stocks
  has_many :storages, through: :stocks
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, presence: true
  validates :reference, presence: true, uniqueness: true
end
