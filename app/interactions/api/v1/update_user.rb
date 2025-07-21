# frozen_string_literal: true

module Api
  module V1
    class UpdateUser < ActiveInteraction::Base
      integer :id

      string  :first_name, :last_name, :email, :phone_number, :gender,
              :city, :state, :country, :password, :password_confirmation,
              default: nil
      integer :age, default: nil
      date    :date_of_birth, default: nil

      validate :validate_age_and_dob_match

      def execute
        user = User.find(id)

        user.assign_attributes(filtered_inputs)

        return user if user.save

        errors.merge!(user.errors)
        nil
      rescue ActiveRecord::RecordNotFound
        errors.add(:id, 'User not found')
        nil
      end

      private

      def filtered_inputs
        inputs.except(:id).select { |_key, value| value.present? }
      end

      def validate_age_and_dob_match
        return if age.blank? || date_of_birth.blank?

        today = Date.today
        dob_this_year = date_of_birth.change(year: today.year)

        calculated_age = today.year - date_of_birth.year
        calculated_age -= 1 if today < dob_this_year

        errors.add(:age, 'does not match date of birth') if calculated_age != age
      end
    end
  end
end
