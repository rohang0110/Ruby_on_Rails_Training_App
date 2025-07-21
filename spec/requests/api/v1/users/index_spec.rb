# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /api/v1/users' do
    let!(:john_doe)     { create(:user, first_name: 'John', last_name: 'Doe', email: 'john@example.com') }
    let!(:jane_doe)     { create(:user, first_name: 'Jane', last_name: 'Doe') }
    let!(:john_smith)   { create(:user, first_name: 'John', last_name: 'Smith') }

    def parsed_response
      JSON.parse(response.body)
    end

    context 'without filters' do
      before { get '/api/v1/users' }

      it 'returns HTTP success' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all users' do
        expect(parsed_response.size).to eq(3)
      end

      it 'returns only selected attributes' do
        parsed_response.each do |user|
          expect(user.keys).to contain_exactly('id', 'first_name', 'last_name', 'email', 'created_at')
        end
      end
    end

    context 'when filtering by first_name' do
      it 'returns users with the given first name' do
        get '/api/v1/users', params: { first_name: 'John' }

        expect(response).to have_http_status(:ok)
        expect(parsed_response.map { |u| u['first_name'] }).to all(eq('John'))
        expect(parsed_response.size).to eq(2)
      end
    end

    context 'when filtering by first_name and last_name' do
      it 'returns matching user' do
        get '/api/v1/users', params: { first_name: 'John', last_name: 'Doe' }

        expect(response).to have_http_status(:ok)
        expect(parsed_response.size).to eq(1)
        expect(parsed_response.first['first_name']).to eq('John')
        expect(parsed_response.first['last_name']).to eq('Doe')
      end
    end

    context 'when filtering by email' do
      it 'returns the correct user' do
        get '/api/v1/users', params: { email: 'john@example.com' }

        expect(response).to have_http_status(:ok)
        expect(parsed_response.size).to eq(1)
        expect(parsed_response.first['email']).to eq('john@example.com')
      end
    end
  end
end
