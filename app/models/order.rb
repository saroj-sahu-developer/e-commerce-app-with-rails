class Order < ApplicationRecord
  has_many :orders_products, dependent: nullify
  has_many :products, through: :orders_products
  belongs_to :user
  belongs_to :address

  validate :ordered_at, presence: true
  STATUS_OPTIONS = ["Pending", "Processing", "Shipped", "Delivered", "Cancelled", "Refunded", "On Hold", "Completed", "Failed"]
  validate :status, presence: true, inclusion: { in: STATUS_OPTIONS,
  message: "Order's status should be among #{STATUS_OPTIONS}." }
  
end
