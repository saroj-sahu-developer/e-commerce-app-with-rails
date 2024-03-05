require 'rails_helper'

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
      subject.street = 'a' * 256
      expect(subject).to_not be_valid
    end

    it 'is not valid if city length exceeds 255 characters' do
      subject.city = 'a' * 256
      expect(subject).to_not be_valid
    end

    it 'is not valid if state length exceeds 255 characters' do
      subject.state = 'a' * 256
      expect(subject).to_not be_valid
    end

    it 'is not valid if country length exceeds 255 characters' do
      subject.country = 'a' * 256
      expect(subject).to_not be_valid
    end

    it 'is not valid if zip_code length exceeds 255 characters' do
      subject.zip_code = 'a' * 21
      expect(subject).to_not be_valid
    end
  end

  context 'associations' do
    it 'belongs to an user' do
      user = create(:user)
      address = create(:address, user: user)

      expect(address.user).to eq(user)
    end

    it 'is not valid without associating an user' do
      subject.user = nil
      expect(subject).to_not be_valid
    end
  end
end
