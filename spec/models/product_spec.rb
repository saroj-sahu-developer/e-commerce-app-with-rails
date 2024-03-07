require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product) }

  context "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without price" do
      subject.price = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without quantity_available" do
      subject.quantity_available = nil
      expect(subject).to_not be_valid
    end

    it "is not valid if name is greater than 255 characters" do
      subject.name = string_having_more_than_255_characters
      expect(subject).to_not be_valid
    end

    it "is not valid if description is greater than 1000 characters" do
      subject.description = string_having_more_than_1000_characters
      expect(subject).to_not be_valid
    end

    it "is valid even without description" do
      subject.description = nil
      expect(subject).to be_valid
    end

    it "is not valid if price is less than 0" do
      subject.price = -Faker::Number.decimal.to_f
      expect(subject).to_not be_valid
    end

    it "is not valid if quantity_available is less than 0" do
      subject.price = -Faker::Number.decimal
      expect(subject).to_not be_valid
    end

    it "is valid with valid image types" do
      file_path = Rails.root.join('app', 'assets', 'images', 'products', 'img-1.jpg')
      subject.images.attach(io: File.open(file_path), filename: 'img-1.jpg')
      expect(subject).to be_valid
    end

    it "is not valid with files other than images" do
      file_path = Rails.root.join('app', 'assets', 'images', 'products', 'pdf-1.pdf')
      subject.images.attach(io: File.open(file_path), filename: 'pdf-1.pdf')
      expect(subject).to_not be_valid
    end
  end

  context "associations" do
    it "belongs to a category" do
      category = create(:category)
      product = create(:product, category: category)

      expect(product.category).to eq(category)
    end
  end
end
