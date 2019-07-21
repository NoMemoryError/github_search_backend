# frozen_string_literal: true

RSpec.describe 'GET /repositories' do
  let(:mocked_response) do
    {
      total_count: 5,
      items: [
        { id: 'id_1',
          name: 'name_1',
          description: 'description_1',
          url: 'url_1',
          license: { name: 'MIT', url: 'url' } },
        { id: 'id_2',
          name: 'name_2',
          description: 'description_2',
          url: 'url_2',
          license: { name: 'MIT', url: 'url' } }
      ]
    }
  end

  let(:context) { double(:context, success?: true, response: mocked_response) }
  let(:params) { { query: 'query' } }

  before { allow(FetchRepositories).to receive(:call).and_return(context) }

  it 'returns with success' do
    get '/repositories', params: params
    expect(response.status).to eq(200)
    expect(response.body).to include_json(data: mocked_response)
  end
end
