require 'rails_helper'

RSpec.describe Cart, type: :model do
  context "association" do
    it "belongs to a user" do
      user = create(:user, :customer)
      cart = create(:cart, user: user)

      expect(cart.user).to eq(user)
    end

    it "has many carts_products and many products through carts_products" do
      product1 = create(:product)
      product2 = create(:product)
      cart = create(:cart)
      carts_product1 = create(:carts_product, cart: cart, product: product1)
      carts_product2 = create(:carts_product, cart: cart, product: product2)

      expect(cart.carts_products).to include(carts_product1, carts_product2)
      expect(cart.products).to include(product1, product2)
    end
  end
end
