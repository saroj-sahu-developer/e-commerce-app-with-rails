require 'rails_helper'

RSpec.describe OrdersProduct, type: :model do
  subject { create(:orders_product) }
  context "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid if order_id and product_id is not unique together" do
      order_id = subject.order_id
      product_id= subject.product_id

      subject2 = build(:orders_product, order_id: order_id, product_id: product_id)
      expect(subject2).to_not be_valid
    end

    it "is not valid if product_quantity is not integer or less than 1" do
      subject.product_quantity = Faker::Number.between(from: -100, to: 0).to_i
      expect(subject).to_not be_valid

      subject.product_quantity = Faker::Number.decimal.to_f
      expect(subject).to_not be_valid
    end
  end

  context "associations" do
    it "belongs to order" do
      order = create(:order)
      orders_product = create(:orders_product, order: order)

      expect(orders_product.order).to eq(order)
    end

    it "belongs to product" do
      product = create(:product)
      orders_product = create(:orders_product, product: product)

      expect(orders_product.product).to eq(product)
    end
  end
end
