require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { create(:order) }

  context "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid when status is other than Initialised, Processing, Shipped, Delivered, Cancelled, Failed" do
      valid_statuses = ["Initialised", "Processing", "Shipped", "Delivered", "Cancelled", "Failed"]
      random_status = Faker::Lorem.word until !valid_statuses.include?(random_status)
      subject.status = random_status

      expect(subject).to_not be_valid
    end
  end

  context "state machine" do
    it 'initializes with the correct state' do
      expect(subject.status).to eq("Initialised")
    end

    it 'transitions to Processing when processing the order' do
      order = build(:order, status: "Initialised")
      order.process_order
      expect(order.status).to eq("Processing")
    end

    it 'transitions to Shipped when shipping the order' do
      order = build(:order, status: "Processing")
      order.ship_order
      expect(order.status).to eq("Shipped")
    end

    it 'transitions to Delivered when delivering the order' do
      order = build(:order, status: "Shipped")
      order.deliver_order
      expect(order.status).to eq("Delivered")
    end

    it 'transitions to Cancelled when canceling the order' do
      before_cancel = ["Initialised", "Processing", "Shipped"]
      order = build(:order, status: before_cancel.sample)
      order.cancel_order
      expect(order.status).to eq("Cancelled")
    end

    it 'transitions to Failed when failing the order' do
      before_fail = ["Initialised", "Processing", "Shipped"]
      order = build(:order, status: before_fail.sample)
      order.fail_order
      expect(order.status).to eq("Failed")
    end
  end
end
