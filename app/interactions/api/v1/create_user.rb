# frozen_string_literal: true

module Api
  module V1
    # Handles the user creation logic for API V1 using ActiveInteraction
    class CreateUser < ActiveInteraction::Base
      string :first_name, :last_name, :email, :phone_number, :password, :password_confirmation
      integer :age
      date :date_of_birth

      validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
      validates :password, confirmation: true
      validates :password_confirmation, presence: true
      validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
      validates :phone_number, format: { with: /\A\d{10}\z/, message: 'must be 10 digits' }

      def execute
        user = User.new(inputs)
        if user.save
          user
        else
          errors.merge!(user.errors)
          nil
        end
      end
    end
  end
end
