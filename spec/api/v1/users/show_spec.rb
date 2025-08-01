# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/users/:id', type: :request do
  let!(:user) { create(:user) }

  context 'when the user exists' do
    it 'returns the user with status 200' do
      get "/api/v1/users/#{user.id}", as: :json

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to include(
        'id' => user.id,
        'first_name' => user.first_name,
        'last_name' => user.last_name,
        'email' => user.email
      )
    end
  end

  context 'when the user does not exist' do
    it 'returns 404 with an error message' do
      get '/api/v1/users/999999', as: :json

      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json['error']).to eq('User not found')
    end
  end
end
