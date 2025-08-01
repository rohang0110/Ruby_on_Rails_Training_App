# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/users/:id', type: :request do
  let!(:user) { create(:user) }
  let(:token) { create(:token) }

  describe 'Unauthorized access' do
    it_behaves_like 'unauthorized access', :delete, "/api/v1/users/#{user.id}"
  end

  context 'when the user exists' do
    it 'deletes the user and returns success message' do
      delete "/api/v1/users/#{user.id}", headers: { 'Authorization' => token.value }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json['message']).to eq('User deleted successfully.')
      expect(User.exists?(user.id)).to be_falsey
    end
  end

  context 'when the user does not exist' do
    it 'returns a not found error' do
      delete '/api/v1/users/0', headers: { 'Authorization' => token.value }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['errors']).to include('User not found')
    end
  end
end
