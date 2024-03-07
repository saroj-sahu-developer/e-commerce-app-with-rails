require 'rails_helper'
require 'support/custom_helpers'

RSpec.describe Address, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  subject { build(:address) }

  context 'validations' do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a street" do
      subject.street = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a city" do
      subject.city = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a zip_code" do
      subject.zip_code = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a country" do
      subject.country = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid if street length exceeds 255 characters' do
      subject.street = string_having_more_than_255_characters
      expect(subject).to_not be_valid
    end

    it 'is not valid if city length exceeds 255 characters' do
      subject.city = string_having_more_than_255_characters
      expect(subject).to_not be_valid
    end

    it 'is not valid if state length exceeds 255 characters' do
      subject.state = string_having_more_than_255_characters
      expect(subject).to_not be_valid
    end

    it 'is not valid if country length exceeds 255 characters' do
      subject.country = string_having_more_than_255_characters
      expect(subject).to_not be_valid
    end

    it 'is not valid if zip_code length exceeds 20 characters' do
      subject.zip_code = string_having_more_than_20_characters
      expect(subject).to_not be_valid
    end
  end

  context 'associations' do
    it 'belongs to an user' do
      user = create(:user, :customer)
      address = create(:address, user: user)

      expect(address.user).to eq(user)
    end

    it 'is not valid without associating an user' do
      subject.user = nil
      expect(subject).to_not be_valid
    end
  end
end
