# frozen_string_literal: true

# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    # Controller for API v1 Users endpoint. Returns user data as JSON.
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token

      # API Documentation: List all users
      api :GET, '/api/v1/users', 'List all users'
      description 'Retrieves a list of all registered users with specified attributes.'
      formats ['json']
      def index
        @users = User.all
        render json: @users, each_serializer: UserSerializer
      end

      # API Documentation: Create a new user
      api :POST, '/api/v1/users', 'Register a new user'
      param :first_name, String, required: true
      param :last_name, String, required: true
      param :email, String, required: true
      param :phone_number, String, required: true
      param :age, Integer, required: true
      param :date_of_birth, String, required: true, desc: 'Format: YYYY-MM-DD'
      param :password, String, required: true
      param :password_confirmation, String, required: true

      def create
        result = Api::V1::CreateUser.run(user_params)

        if result.valid?
          render json: result.result, serializer: UserSerializer, status: :created
        else
          render json: { errors: result.errors.messages }, status: :unprocessable_entity
        end
      end

      private

      # Strong params with manual type casting (Apipie expects real Integer, not string)
      def user_params
        permitted = params.permit(
          :first_name, :last_name, :email, :phone_number,
          :age, :date_of_birth, :password, :password_confirmation
        ).to_h

        # Cast age to Integer if present, or leave nil if missing/invalid
        permitted['age'] = begin
          Integer(permitted['age'])
        rescue StandardError
          nil
        end
        permitted
      end
      api :GET, '/api/v1/users/:id', 'Fetch user by ID'
      param :id, :number, required: true, desc: 'ID of the user'
      description 'Returns a single user based on the provided ID.'
      formats ['json']

      def show
        user = User.find_by(id: params[:id])

        if user
          render json: user, serializer: UserSerializer, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end
    end
  end
end
