FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }
    description { Faker::Lorem.paragraph_by_chars(number: 1000, supplemental: false) }
    location { Faker::Address.full_address }
    cuisine_type { Faker::Restaurant.type }
    rating { rand(1..5) }
    status { :open }
    note { Faker::Lorem.sentence }
    likes { rand(0..1000) }
    association :user, factory: :staff_user
  end
end
