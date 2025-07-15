# lib/build/database_builder.rb

require 'faker'

module Build
  class DatabaseBuilder
    def reset_data
      User.destroy_all
      puts 'All users destroyed'
    end

    def create_users
      10.times do
        dob = Faker::Date.birthday(min_age: 18, max_age: 60)
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
          password_confirmation: 'Password@123'
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

    def execute
      reset_data
      create_users
    end

    # This method is called to run the database builder
    def run
      execute
    end
  end
end
