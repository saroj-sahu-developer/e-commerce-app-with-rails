FactoryBot.define do
  factory :orders_product do
    association :order, factory: :order
    # association :product, factory: :product
    product { build(:product) }

    product_quantity { Faker::Number.between(from: 1, to: 100) }
    product_unit_price { product.price }
  end
end
