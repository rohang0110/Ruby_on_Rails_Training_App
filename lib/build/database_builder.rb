# frozen_string_literal: true

require 'faker'

module Build
  class DatabaseBuilder
    def reset_data
      Restaurant.destroy_all
      User.destroy_all
      puts 'All restaurants and users destroyed'
    end

    def create_users
      10.times do
        dob = Faker::Date.birthday(min_age: 18, max_age: 60)
        age = calculate_age_from_dob(dob)
        today = Date.today
        age = today.year - dob.year
        age -= 1 if dob > Date.new(today.year, dob.month, dob.day)

        User.create!(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.unique.email,
          age: age,
          date_of_birth: dob,
          phone_number: Faker::Number.number(digits: 10),
          password: 'Password@123',
          password_confirmation: 'Password@123',
          role_type: :customer,
          status: :active
        )
      end
      puts '10 users created'
    end

    def calculate_age_from_dob(dob)
      today = Date.today
      age = today.year - dob.year
      age -= 1 if Date.new(today.year, dob.month, dob.day) > today
      age
    end

    def create_restaurants
      users = User.all
      return puts 'No users found. Seed users first.' if users.blank?

      puts 'Seeding Restaurants...'

      seed_restaurants_with_status(:open, 20, users)
      seed_restaurants_with_status(:closed, 20, users)
      seed_restaurants_with_status(:archived, 20, users)

      puts 'Finished seeding restaurants'
    end

    def seed_restaurants_with_status(status, count, users)
      count.times do
        Restaurant.create!(
          name: Faker::Restaurant.name,
          description: Faker::Lorem.paragraph_by_chars(number: 1000, supplemental: false),
          location: Faker::Address.city,
          cuisine_type: Faker::Restaurant.type,
          rating: rand(1..5),
          status: status,
          user: users.sample
        )
      end
    end

    def execute
      reset_data
      create_users
      create_restaurants
    end

    def run
      execute
    end
  end
end
