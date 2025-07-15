# frozen_string_literal: true

# app/serializers/user_serializer.rb
class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :created_at
end
