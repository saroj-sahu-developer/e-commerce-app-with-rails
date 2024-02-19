class Payment < ApplicationRecord
  belongs_to :order

  VALID_PAYMENT_MODES = ['Credit Card', 'Debit Card', 'Net Banking', 'UPI', 'COD']
  VALID_PAYMENT_STATUSES = ['Pending', 'Completed', 'Failed', 'Refunded', 'Cancelled']
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :payment_mode, presence: true, inclusion: { in: VALID_PAYMENT_MODES, message: "payment mode should be among #{VALID_PAYMENT_MODES}." }
  validates :payment_status, inclusion: { in: VALID_PAYMENT_STATUSES, message: "payment status should be among #{VALID_PAYMENT_STATUSES}." }
end
