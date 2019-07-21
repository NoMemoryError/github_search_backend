# frozen_string_literal: true

RSpec.describe FetchRepositories do
  subject { described_class.call(query: query, per_page: 5) }

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

  context 'api_success' do
    before do
      allow_any_instance_of(Octokit::Client).to receive(:search_repositories)
        .with(query, per_page: 5).and_return(mocked_response)
    end
    context 'with valid query' do
      let(:query) { 'good_input' }

      it { is_expected.to be_success }

      it 'verifies response' do
        expect(subject.response).to be_present
        expect(subject.response[:total_count]).to eq(5)
      end
    end

    context 'with empty query' do
      let(:query) { '' }

      it { is_expected.to be_success }

      it 'verifies response' do
        expect(subject.response).to be_present
        expect(subject.response[:total_count]).to eq(0)
      end
    end
  end

  context 'api_failure' do
    before do
      allow_any_instance_of(Octokit::Client).to receive(:search_repositories)
        .and_raise(Octokit::UnprocessableEntity)
    end

    let(:query) { 'bad_input' }

    it { is_expected.to be_failure }
    it 'populate_error_message' do
      expect(subject.message).to be_present
    end
  end
end
