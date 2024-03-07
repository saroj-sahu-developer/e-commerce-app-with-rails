require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  include Devise::Test::ControllerHelpers
  include Pundit::Authorization

  let(:user) { FactoryBot.create(:user, :customer) }
  let(:address) { FactoryBot.create(:address, user: user) }
  let(:valid_params) do
    {
      address_id: address.id,
      payment_mode: ['Credit Card', 'Debit Card', 'Net Banking', 'UPI', 'COD'].sample,
      total_amount: Faker::Commerce.price(range: 0..1000000.0)
    }
  end
  let(:cart) { user.cart } # User model create a cart for user, after_save a user

  before do
    sign_in user
    create(:carts_product, cart: cart)
    # As while creating order, create method will fetch products from cart
  end

  describe 'POST #create' do
    it 'creates a new order' do
      orders_count = Order.count
      payment_count = Order.count

      post :create, params: valid_params

      expect(Order.count).to eq(orders_count + 1)
      expect(Order.last.user).to eq(user)
      expect(Payment.count).to eq(payment_count + 1)
    end
  end

  describe 'GET #index' do
    it 'returns all orders in @orders_with_product_details' do
      order = FactoryBot.create(:order, user: user)
      create(:orders_product, order: order)

      get :index
      expect(assigns(:orders_with_product_details)).to include(order)
    end
  end

  describe 'GET #show' do
    it 'returns the requested order with product details in @order_with_product_details' do
      order = FactoryBot.create(:order, user: user)
      create(:orders_product, order: order)

      get :show, params: { id: order.id }

      expect(assigns(:payment)).to eq(order.payment)
      expect(assigns(:order)).to eq(order)
      expect(assigns(:order_with_product_details)).to eq(order.orders_products)
    end
  end

  describe 'PATCH #update' do
    it 'updates the requested order with a valid status' do
      user.update(role: 'admin') # As only admin can perform
      order = FactoryBot.create(:order, user: user)

      patch :update, params: { id: order.id, status: 'Processing' }
      expect(order.reload.status).to eq('Processing')

      patch :update, params: { id: order.id, status: 'Shipped' }
      expect(order.reload.status).to eq('Shipped')

      patch :update, params: { id: order.id, status: 'Delivered' }
      expect(order.reload.status).to eq('Delivered')

      # order.reload tends to the updated order after DB call
    end
  end

  describe 'PATCH #bulk_update' do
    it 'updates multiple orders with a valid status' do
      user.update(role: 'admin') # As only admin can perform
      orders = FactoryBot.create_list(:order, 10)

      patch :bulk_update, params: { order_ids: orders.map(&:id), status: 'Processing' }
      expect(orders.map(&:reload).map(&:status)).to all(eq('Processing'))

      patch :bulk_update, params: { order_ids: orders.map(&:id), status: 'Shipped' }
      expect(orders.map(&:reload).map(&:status)).to all(eq('Shipped'))

      patch :bulk_update, params: { order_ids: orders.map(&:id), status: 'Cancelled' }
      expect(orders.map(&:reload).map(&:status)).to all(eq('Cancelled'))
    end
  end
end
