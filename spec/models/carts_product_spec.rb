require 'rails_helper'

RSpec.describe CartsProduct, type: :model do
  subject { create(:carts_product) }
  context "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid if cart_id and product_id is not unique together" do
      cart_id = subject.cart_id
      product_id= subject.product_id

      subject2 = build(:carts_product, cart_id: cart_id, product_id: product_id)
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
    it "belongs to cart" do
      cart = create(:cart)
      carts_product = create(:carts_product, cart: cart)

      expect(carts_product.cart).to eq(cart)
    end

    it "belongs to product" do
      product = create(:product)
      carts_product = create(:carts_product, product: product)

      expect(carts_product.product).to eq(product)
    end
  end
end
