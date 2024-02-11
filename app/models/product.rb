class Product < ApplicationRecord
  belongs_to :category, optional: true

  validates :name, presence:true, length: { maximum: 255 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, length: { maximum: 1000 }
  validates :quantity_available, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :carts_products, dependent: :destroy
end
