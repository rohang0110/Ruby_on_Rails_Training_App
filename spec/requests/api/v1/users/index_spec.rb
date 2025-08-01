# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /api/v1/users' do
    let!(:users) { create_list(:user, 3) }

    before do
      get '/api/v1/users'
    end

    it 'returns HTTP success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a list of users' do
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.size).to eq(3)
    end

    it 'returns only selected attributes' do
      json = JSON.parse(response.body)
      json.each do |user|
        expect(user.keys).to contain_exactly(
          'id', 'first_name', 'last_name', 'email', 'created_at'
        )
      end
    end
  end
end
