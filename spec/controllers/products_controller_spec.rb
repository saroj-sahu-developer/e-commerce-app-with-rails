require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  include Devise::Test::ControllerHelpers
  include Pundit::Authorization

  let(:user) { FactoryBot.create(:user, :admin) }
  let(:valid_params) { { product: { name: Faker::Commerce.product_name, description: Faker::Lorem.sentence, price: Faker::Commerce.price(range: 0..1000.0), quantity_available: Faker::Number.between(from: 0, to: 100) } } }

  before do
    user.update(role: 'admin') # As after user get created, it will be assign role as 'customer' by Order model.
    sign_in user
  end

  describe 'GET #index' do
    it 'returns all products in @products when category_id is nil or "all"' do
      product1 = create(:product)
      product2 = create(:product)

      get :index
      expect(assigns(:products)).to include(product1, product2)

      valid_params[:category_id] = 'all'
      get :index, params: valid_params
      expect(assigns(:products)).to include(product1, product2)
    end

    it 'returns products from the particular category in @products when category_id provided' do
      category = create(:category)
      product1 = create(:product, category: category)
      product2 = create(:product)

      valid_params[:category_id] = category.id
      get :index, params: valid_params

      expect(assigns(:products)).to include(product1)
      expect(assigns(:products)).to_not include(product2)
    end
  end

  describe 'POST #create' do
    it 'creates a new product' do
      category = create(:category)
      valid_params[:product][:category_id] = category.id
      product_count = Product.count

      post :create, params: valid_params

      expect(Product.count).to eq(product_count + 1)
      expect(Product.last.name).to eq(valid_params[:product][:name])
      expect(Product.last.description).to eq(valid_params[:product][:description])
      expect(Product.last.price).to eq(valid_params[:product][:price])
      expect(Product.last.quantity_available).to eq(valid_params[:product][:quantity_available])
      expect(Product.last.category.id).to eq(valid_params[:product][:category_id])
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested product' do
      product = create(:product)
      product_count = Product.count
      delete :destroy, params: { id: product.id }

      expect(Product.count).to eq(product_count - 1)
      expect(Product.find_by(id: product.id)).to be_nil
    end
  end

  describe 'PUT #update' do
    it 'updates the requested product' do
      product = create(:product)
      valid_params[:id] = product.id

      put :update, params: valid_params

      updated_product = product.reload

      expect(updated_product.name).to eq(valid_params[:product][:name])
      expect(updated_product.description).to eq(valid_params[:product][:description])
      expect(updated_product.price).to eq(valid_params[:product][:price])
      expect(updated_product.quantity_available).to eq(valid_params[:product][:quantity_available])
    end
  end
end
