class Storage < ApplicationRecord
  has_many :stocks
  has_many :products, through: :stocks
  has_many :orders

  validates :name, presence: true
end
