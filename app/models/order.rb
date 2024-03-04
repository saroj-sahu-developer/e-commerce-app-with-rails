class Order < ApplicationRecord
  include AASM

  has_many :orders_products
  has_many :products, through: :orders_products
  belongs_to :user
  belongs_to :address
  has_one :payment

  STATUS_OPTIONS = ["Initialised", "Processing", "Shipped", "Delivered", "Cancelled", "Failed"]
  validates :status, inclusion: { in: STATUS_OPTIONS, message: "Order's status should be among #{STATUS_OPTIONS}." }

  aasm(:status) do
    # states
    state :Initialised, initial: true
    state :Processing
    state :Shipped
    state :Delivered
    state :Cancelled
    state :Failed

    # events
    event :process_order do
      transitions from: :Initialised, to: :Processing
    end

    event :ship_order do
      transitions from: :Processing, to: :Shipped
    end

    event :deliver_order do
      transitions from: :Shipped, to: :Delivered
    end

    event :cancel_order do
      transitions from: [:Initialised, :Processing, :Shipped], to: :Cancelled
    end

    event :fail_order do
      transitions from: [:Initialised, :Processing, :Shipped], to: :Failed
    end
  end

  after_save :dispatch_order

  private
  def dispatch_order
    DispatchOrderJob.set(wait: 20.seconds).perform_later(self, :process_order)
    DispatchOrderJob.set(wait: 30.seconds).perform_later(self, :ship_order)
    DispatchOrderJob.set(wait: 40.seconds).perform_later(self, :deliver_order)
  end
end
