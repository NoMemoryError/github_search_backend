# frozen_string_literal: true

RSpec.describe '/health' do
  it 'returns health status' do
    get '/health'
    expect(response.status).to eq(200)
    expect(response.body).to include_json(status: 'healthy')
  end
end
