require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  include Devise::Test::ControllerHelpers
  include Pundit::Authorization

  let(:user) { FactoryBot.create(:user, :customer) }
  let(:product) { FactoryBot.create(:product) }

  before do
    sign_in user
  end

  describe 'GET #show_cart' do
    it "returns the user's cart with products and total amount" do
      carts_product1 = FactoryBot.create(:carts_product, cart: user.cart, product: product)
      product2 = create(:product)
      carts_product2 = FactoryBot.create(:carts_product, cart: user.cart, product: product2)

      get :show_cart

      expect(assigns(:cart)).to eq(user.cart)
      expect(assigns(:carts_products)).to include(carts_product1, carts_product2)
      expect(assigns(:total_amonut_in_cart)).to eq((carts_product1.product.price * carts_product1.product_quantity) + (carts_product2.product.price * carts_product2.product_quantity))
    end
  end

  describe 'POST #add_product_to_cart' do
    context 'when adding a new product to the cart' do
      it 'creates a new CartsProduct record' do
        post :add_product_to_cart, params: { product_id: product.id }

        expect(user.cart.carts_products.count).to eq(1)
        expect(user.cart.carts_products.last.product).to eq(product)
        expect(user.cart.carts_products.last.product_quantity).to eq(1)
      end
    end

    context 'when updating the quantity of an existing product in the cart' do
      it 'updates the product quantity' do
        carts_product = FactoryBot.create(:carts_product, cart: user.cart, product: product, product_quantity: 1)

        post :add_product_to_cart, params: { product_id: product.id, product_quantity: 3 }

        carts_product.reload
        expect(carts_product.product_quantity).to eq(3)
      end
    end
  end

  describe 'DELETE #delete_product_from_cart' do
    it 'deletes the specified product from the cart' do
      carts_product = FactoryBot.create(:carts_product, cart: user.cart, product: product)

      delete :delete_product_from_cart, params: { product_id: product.id }

      expect(user.cart.carts_products.count).to eq(0)
    end
  end
end
