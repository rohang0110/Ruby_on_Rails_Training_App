# frozen_string_literal: true

module Api
  module V1
    class UpdateUser < ActiveInteraction::Base
      integer :id

      string :first_name, :last_name, :email, :phone_number, :gender, :city, :state, :country, :password,
             :password_confirmation, default: nil
      integer :age, default: nil
      date :date_of_birth, default: nil

      validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
      validates :phone_number, length: { is: 10 }, allow_nil: true
      validates :gender, inclusion: { in: %w[male female other] }, allow_nil: true

      validate :check_user_presence
      validate :validate_age_and_dob_match

      def execute
        return unless user

        Rails.logger.debug "INPUTS: #{inputs.inspect}"
        user.assign_attributes(filtered_inputs)

        unless user.save
          errors.merge!(user.errors)
          return
        end

        user
      end

      private

      def user
        @user ||= User.find_by(id: id)
      end

      def check_user_presence
        errors.add(:id, 'User not found') unless user
      end

      def filtered_inputs
        inputs.except(:id).select { |_k, v| !v.nil? && !(v.respond_to?(:empty?) && v.empty?) }
      end

      def validate_age_and_dob_match
        return if age.blank? || date_of_birth.blank?

        today = Date.today
        dob_this_year = date_of_birth.change(year: today.year)
        calculated_age = today.year - date_of_birth.year
        calculated_age -= 1 if today < dob_this_year

        return unless calculated_age != age

        errors.add(:age, 'does not match date of birth')
      end
    end
  end
end
