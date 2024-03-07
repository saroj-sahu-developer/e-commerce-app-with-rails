require 'rails_helper'

RSpec.describe AddressesController, type: :controller do
  include Devise::Test::ControllerHelpers
  include Pundit::Authorization

  let(:user) { FactoryBot.create(:user, :customer) }
  let(:valid_params) { { address: { street: Faker::Address.street_address, city: Faker::Address.city, state: Faker::Address.state, zip_code: Faker::Address.zip_code, country: Faker::Address.country } } }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns all addresses in @addresses' do

      address1 = create(:address, user: user)
      address2 = create(:address, user: user)

      get :index
      expect(assigns(:addresses)).to include(address1, address2)
    end
  end

  describe 'POST #create' do
    it 'creates a new address' do
      addresses_count = Address.count
      post :create, params: valid_params

      expect(Address.count).to eq(addresses_count + 1)
      expect(Address.last.street).to eq(valid_params[:address][:street])
      expect(Address.last.city).to eq(valid_params[:address][:city])
      expect(Address.last.state).to eq(valid_params[:address][:state])
      expect(Address.last.zip_code).to eq(valid_params[:address][:zip_code])
      expect(Address.last.country).to eq(valid_params[:address][:country])
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested address' do
      address = create(:address, user: user)
      address_count = Address.count
      delete :destroy, params: { id: address.id }

      expect(Address.count).to eq(address_count - 1)
      expect(Address.find_by(id: address.id)).to be_nil
    end
  end

  describe 'PUT #update' do
    it 'updates the requested address' do
      address = create(:address, user: user)
      valid_params[:id] = address.id

      put :update, params: valid_params

      updated_address = address.reload

      expect(updated_address.street).to eq(valid_params[:address][:street])
      expect(updated_address.city).to eq(valid_params[:address][:city])
      expect(updated_address.state).to eq(valid_params[:address][:state])
      expect(updated_address.zip_code).to eq(valid_params[:address][:zip_code])
      expect(updated_address.country).to eq(valid_params[:address][:country])
    end
  end
end
