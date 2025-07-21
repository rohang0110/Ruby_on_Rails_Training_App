# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /api/v1/users/:id', type: :request do
  let!(:user) { create(:user, first_name: 'OldName') }
  let(:token) { create(:token) }
  let(:headers) { { 'Authorization' => token.value } }
  let(:json) { JSON.parse(response.body) }

  describe 'Unauthorized access' do
    it_behaves_like 'unauthorized access', :put, "/api/v1/users/#{user.id}", {
      user: { first_name: 'NewName' }
    }
  end

  context 'when updating valid fields' do
    it 'updates user and returns 200' do
      put "/api/v1/users/#{user.id}", params: {
        user: { first_name: 'NewName' }
      }, headers: headers, as: :json

      expect(response).to have_http_status(:ok)
      expect(json['first_name']).to eq('NewName')
    end
  end

  context 'when user does not exist' do
    it 'returns 422' do
      put '/api/v1/users/999999', params: {
        user: { first_name: 'Ghost' }
      }, headers: headers, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']['id']).to include('User not found')
    end
  end

  context 'when age and date_of_birth mismatch' do
    it 'returns validation error' do
      put "/api/v1/users/#{user.id}", params: {
        user: { age: 30, date_of_birth: 20.years.ago.to_date }
      }, headers: headers, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']['age']).to include('does not match date of birth')
    end
  end
end
