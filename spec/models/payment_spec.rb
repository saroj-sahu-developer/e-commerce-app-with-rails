require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject { build(:payment) }
  VALID_PAYMENT_MODES = ['Credit Card', 'Debit Card', 'Net Banking', 'UPI', 'COD']
  VALID_PAYMENT_STATUSES = ['Pending', 'Completed', 'Failed', 'Refunded', 'Cancelled']

  context "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid if payment_mode is absent or not among VALID_PAYMENT_MODES" do
      subject.payment_mode = nil
      expect(subject).to_not be_valid

      random_payment_mode = Faker::Lorem.word until !VALID_PAYMENT_MODES.include?(random_payment_mode)
      subject.payment_mode = random_payment_mode
      expect(subject).to_not be_valid
    end

    it "is not valid if payment_status is absent or not among VALID_PAYMENT_STATUSES" do
      subject.payment_status = nil
      expect(subject).to_not be_valid

      random_payment_status = Faker::Lorem.word until !VALID_PAYMENT_STATUSES.include?(random_payment_status)
      subject.payment_status = random_payment_status
      expect(subject).to_not be_valid
    end

    it "is not valid if total_amount is absent or less than 0" do
      subject.total_amount = nil
      expect(subject).to_not be_valid

      subject.total_amount = Faker::Number.negative
      expect(subject).to_not be_valid
    end
  end

  context "associations" do
    it "belongs to an order" do
      order = create(:order)
      payment = create(:payment, order: order)
      expect(payment.order).to eq(order)
    end
  end
end
