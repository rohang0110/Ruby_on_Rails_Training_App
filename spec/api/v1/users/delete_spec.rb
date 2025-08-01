require 'rails_helper'

RSpec.describe 'DELETE /api/v1/users/:id', type: :request do
  let!(:user) { create(:user) }

  context 'when the user exists' do
    it 'deletes the user and returns success message' do
      delete "/api/v1/users/#{user.id}"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('User deleted successfully.')
      expect(User.exists?(user.id)).to be_falsey
    end
  end

  context 'when the user does not exist' do
    it 'returns a not found error' do
      delete '/api/v1/users/0'

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['errors']).to include('User not found')
    end
  end
end
