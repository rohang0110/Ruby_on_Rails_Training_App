# lib/build/restaurant_builder.rb
module Build
  class RestaurantBuilder
    def initialize
      @users = User.all
    end

    def run
      return puts 'No users found. Please seed users first' if @users.blank?

      puts 'Seeding Restaurants'

      create_restaurants_with_status(:open, 20)
      create_restaurants_with_status(:closed, 20)
      create_restaurants_with_status(:archived, 20)

      puts 'Finished seeding restaurants'
    end

    private

    def create_restaurants_with_status(status, count)
      count.times do
        FactoryBot.create(:restaurant, status: status, user: @users.sample)
      end
    end
  end
end
