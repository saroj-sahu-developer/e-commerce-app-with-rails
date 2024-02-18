class OrdersProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :order_id, presence: true, uniqueness: { scope: :product_id }
  validates :product_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :product_unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
