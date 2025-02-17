require 'rails_helper'

RSpec.describe Category, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  subject { build(:category) }

  context 'validations' do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is valid even without a description" do
      subject.description = nil
      expect(subject).to be_valid
    end
  end

  context 'associations' do
    it "has many products" do
      category = create(:category)
      product1 = create(:product, category: category)
      product2 = create(:product, category: category)

      expect(category.products).to include(product1, product2)
    end
  end
end
