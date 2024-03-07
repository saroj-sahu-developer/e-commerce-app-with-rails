FactoryBot.define do
  factory :carts_product do
    association :cart, factory: :cart
    association :product, factory: :product

    product_quantity { Faker::Number.between(from: 1, to: 100) }
  end
end
