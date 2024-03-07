FactoryBot.define do
  factory :payment do
    association :order, factory: :order

    total_amount { Faker::Commerce.price(range: 0..1000000.0) }
    VALID_PAYMENT_MODES = ['Credit Card', 'Debit Card', 'Net Banking', 'UPI', 'COD']
    payment_mode { VALID_PAYMENT_MODES.sample }
    VALID_PAYMENT_STATUSES = ['Pending', 'Completed', 'Failed', 'Refunded', 'Cancelled']
    payment_status { VALID_PAYMENT_STATUSES.sample }
  end
end
