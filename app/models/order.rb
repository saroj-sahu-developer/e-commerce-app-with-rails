class Order < ApplicationRecord
  has_many :orders_products
  has_many :products, through: :orders_products
  belongs_to :user
  belongs_to :address
  has_one :payment

  STATUS_OPTIONS = ["Initialised", "Processing", "Shipped", "Delivered", "Cancelled", "Refunded", "On Hold", "Completed", "Failed"]
  validates :status, presence: true, inclusion: { in: STATUS_OPTIONS,
  message: "Order's status should be among #{STATUS_OPTIONS}." }

end
