# frozen_string_literal: true

RSpec.shared_examples 'unauthorized access' do |http_method, path, params = {}|
  it 'returns unauthorized when token is missing' do
    send(http_method, path, params: params)
    expect(response).to have_http_status(:unauthorized)
    expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
  end
end
