# frozen_string_literal: true

# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    # Controller for API v1 Users endpoint. Returns user data as JSON.
    class UsersController < ApplicationController
      # Define API documentation for the index action
      api :GET, '/api/v1/users', 'List all users'
      description 'Retrieves a list of all registered users with specified attributes.'
      formats ['json']
      def index
        @users = User.all
        render json: @users, each_serializer: UserSerializer
      end
    end
  end
end
