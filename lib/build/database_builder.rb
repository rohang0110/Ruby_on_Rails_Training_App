# lib/build/database_builder.rb

require 'faker'

module Build
  class DatabaseBuilder
    def reset_data
      puts "Resetting database..."
      User.destroy_all
      puts "All users destroyed."
    end

    def create_users
      puts "Creating users using Faker"

      10.times do
        date_of_birth = Faker::Date.birthday(min_age: 18, max_age: 100)
        age = ((Time.zone.now - date_of_birth.to_time) / 1.year.seconds).floor
        password = Faker::Internet.password(min_length: 6)

        User.create!(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.unique.email,
          phone_number: Faker::Number.number(digits: 10).to_s.rjust(10, '0'),
          date_of_birth: date_of_birth,
          age: age, # Pass the calculated age
          password: password,
          password_confirmation: password
        )
      end

      puts "10 users with Faker data created successfully!"
    end


    def execute
      reset_data
      create_users
    end

    def run
      execute
    end
  end
end
