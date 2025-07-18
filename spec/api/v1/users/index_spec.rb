# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/users', type: :request do
  let!(:john_doe) { create(:user, first_name: 'John', last_name: 'Doe', email: 'john@example.com') }
  let!(:john_milton) { create(:user, first_name: 'John', last_name: 'Milton') }
  let!(:mark_doe) { create(:user, first_name: 'Mark', last_name: 'Doe') }

  it 'returns all users when no filters are applied' do
    get '/api/v1/users'
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).size).to eq(3)
  end

  it 'filters by first_name' do
    get '/api/v1/users', params: { first_name: 'John' }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).map { |u| u['first_name'] }).to all(eq('John'))
  end

  it 'filters by first_name and last_name' do
    get '/api/v1/users', params: { first_name: 'John', last_name: 'Doe' }
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json.size).to eq(1)
    expect(json.first['first_name']).to eq('John')
    expect(json.first['last_name']).to eq('Doe')
  end

  it 'filters by email' do
    get '/api/v1/users', params: { email: 'john@example.com' }
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json.size).to eq(1)
    expect(json.first['email']).to eq('john@example.com')
  end
end
