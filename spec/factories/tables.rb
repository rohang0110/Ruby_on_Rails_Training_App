FactoryBot.define do
  factory :table do
    table_number { Faker::Number.unique.number(digits: 2) }
    seats { Faker::Number.between(from: 2, to: 8) }
    status { :available }
    association :restaurant
  end
end
