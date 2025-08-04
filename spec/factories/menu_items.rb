# spec/factories/menu_items.rb
FactoryBot.define do
  factory :menu_item do
    item_name { Faker::Food.dish }
    description { Faker::Food.description }
    price { Faker::Commerce.price(range: 5..50.0) }
    category { Faker::Restaurant.type }
    available { true }
    association :restaurant
  end
end
