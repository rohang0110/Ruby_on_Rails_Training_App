# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token

      api :GET, '/api/v1/users', 'List all users '
      param :first_name, String, desc: 'Filter by first name '
      param :last_name, String, desc: 'Filter by last name '
      param :email, String, desc: 'Filter by email'
      description 'Retrieves a list of all registered users. Supports filtering by first name, last name, and email.'
      formats ['json']
      def index
        @users = Api::V1::UsersQuery.new(params).call
        render json: @users, each_serializer: UserSerializer
      end

      api :GET, '/api/v1/users/:id', 'Fetch user by ID'
      param :id, :number, required: true, desc: 'ID of the user'
      description 'Returns a single user based on the provided ID.'
      formats ['json']
      def show
        user = User.find(id: params[:id])
        if user
          render json: user, serializer: UserSerializer, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

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
        render_serializer_result(result, :created)
      end

      api :PUT, '/api/v1/users/:id', 'Update an existing user'
      param :id, :number, required: true
      param :first_name, String, required: false
      param :last_name, String, required: false
      param :email, String, required: false
      param :phone_number, String, required: false
      param :age, Integer, required: false
      param :date_of_birth, String, required: false
      param :password, String, required: false
      param :password_confirmation, String, required: false
      def update
        result = Api::V1::UpdateUser.run(user_params(include_id: true))
        render_serializer_result(result, :ok)
      end

      api :DELETE, '/api/v1/users/:id', 'Delete an existing user'
      param :id, :number, required: true, desc: 'ID of the user to be deleted'
      description 'Deletes the user by ID and returns a success message.'
      formats ['json']
      def destroy
        result = Api::V1::DeleteUser.run(id: params[:id])
        if result.valid?
          render json: result.result, status: :ok
        else
          render json: { errors: result.errors.full_messages }, status: :not_found
        end
      end

      private

      # Strong params
      def permitted_user_fields
        %i[
          first_name last_name email phone_number
          age date_of_birth password password_confirmation
        ]
      end

      # Reusable param method for both create and update
      def user_params(include_id: false)
        permitted = params.permit(*permitted_user_fields).to_h
        include_id ? permitted.merge(id: params[:id]) : permitted
      end

      # Common render logic
      def render_serializer_result(result, success_status)
        if result.valid?
          render json: result.result, serializer: UserSerializer, status: success_status
        else
          render json: { errors: result.errors.messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
