# frozen_string_literal: true

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    phone_number { Faker::Number.number(digits: 10).to_s }
    age { 25 }
    date_of_birth { 25.years.ago.to_date }
    password { 'Secure123!' }
    password_confirmation { 'Secure123!' }
    role_type { rand(2..3) }

    factory :staff_user do
      role_type { :staff }
    end

    factory :customer_user do
      role_type { :customer }
    end
  end
end
