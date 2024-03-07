require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  include Devise::Test::ControllerHelpers
  include Pundit::Authorization

  let(:user) { FactoryBot.create(:user, :admin) }
  let(:valid_params) { { category: { name: Faker::Lorem.word, description: Faker::Lorem.sentence } } }

  before do
    user.update(role: 'admin') # As after user get created, it will be assign role as 'customer' by Order model.
    sign_in user
  end

  describe 'GET #index' do
    it 'returns all categories in @categories' do
      category1 = create(:category)
      category2= create(:category)

      get :index

      expect(assigns(:categories)).to include(category1, category2)
    end
  end

  describe 'POST #create' do
    it 'creates a new category' do
      categories_count = Category.count

      post :create, params: valid_params

      expect(Category.count).to eq(categories_count + 1)
      expect(Category.last.name).to eq(valid_params[:category][:name])
      expect(Category.last.description).to eq(valid_params[:category][:description])
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested category' do
      category = create(:category)
      category_count = Category.count

      delete :destroy, params: { id: category.id }

      expect(Category.count).to eq(category_count - 1)
      expect(Category.find_by(id: category.id)).to be_nil
    end
  end

  describe 'PUT #update' do
    it 'updates the requested category' do
      category = create(:category)
      valid_params[:id] = category.id

      put :update, params: valid_params

      updated_category = category.reload
      expect(updated_category.name).to eq(valid_params[:category][:name])
      expect(updated_category.description).to eq(valid_params[:category][:description])
    end
  end
end
