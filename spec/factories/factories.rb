FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    confirmed_at { Time.now }

    trait :confirmed do
      confirmed_at { Time.now }
    end
  end

  factory :portfolio do
    sequence :name do |n|
      "Portfolio #{n}"
    end
    description { "MyText" }

    association :user, factory: :user
  end

  factory :investment do
    symbol { "MyString" }
    purchase_price { 1.5 }
    number_of_shares { 1 }
    purchase_date { "2023-06-21" }

    association :portfolio, factory: :portfolio
  end
end
