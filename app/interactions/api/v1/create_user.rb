# frozen_string_literal: true

module Api
  module V1
    # Handles user creation for API V1 using ActiveInteraction.
    class CreateUser < ActiveInteraction::Base
      string  :first_name, :last_name, :email,
              :phone_number, :password, :password_confirmation
      integer :age
      date    :date_of_birth

      def execute
        user = User.new(inputs)

        return user if user.save

        errors.merge!(user.errors)
        nil
      end
    end
  end
end
