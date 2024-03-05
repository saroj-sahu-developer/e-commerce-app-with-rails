FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 0..1000.0) }
    description { Faker::Lorem.sentence }
    quantity_available { Faker::Number.between(from: 0, to: 100) }

    association :category, factory: :category
  end
end
