FactoryBot.define do
  factory :order do
    association :user, factory: [:user, :customer]
    association :address, factory: :address
  end
end
