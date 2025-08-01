
# frozen_string_literal: true

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    phone_number { Faker::Number.number(digits: 10).to_s }
    date_of_birth { Faker::Date.birthday }
    age { Date.today.year - date_of_birth.year - (Date.today < date_of_birth + (Date.today.year - date_of_birth.year).years ? 1 : 0) }
    password { Faker::Internet.password(min_length: 6)}
    password_confirmation { password }
  end
end