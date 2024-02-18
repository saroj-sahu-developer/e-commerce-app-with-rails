class CartsProduct < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :cart_id, presence: true, uniqueness: { scope: :product_id }
  validates :product_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
