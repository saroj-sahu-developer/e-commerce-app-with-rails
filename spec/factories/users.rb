require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
  end
end
