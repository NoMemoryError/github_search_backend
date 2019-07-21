# frozen_string_literal: true

# Fetches repositories collection from github_api
class FetchRepositories
  include Interactor

  delegate :query, :sort, :page, :per_page, to: :context

  ITEMS_PER_PAGE = 5 # Just going with a random value. Ideally this will also be exposed to the frontend

  def call
    if query.blank?
      context.response = empty_response
      return
    end
    api_response = client.search_repositories(query.strip, options)
    context.response = response(api_response.to_h)
  rescue Octokit::UnprocessableEntity => e
    populate_error_message(e)
    context.fail!
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: Rails.application.credentials.github[:access_token])
  end

  def options
    {}.tap do |opt|
      opt.store(:sort, sort) if sort.present?
      opt.store(:page, page) if page.present?
      opt.store(:per_page, per_page || ITEMS_PER_PAGE)
    end
  end

  def response(api_response)
    {
      total_count: api_response[:total_count],
      items: normalized_repositories_items(api_response[:items])
    }
  end

  def normalized_repositories_items(repositories)
    repositories.map do |repository|
      {
        id: repository[:id],
        name: repository[:full_name],
        description: repository[:description],
        url: repository[:html_url],
        open_issues_count: repository[:open_issues_count],
        stars: repository[:stargazers_count],
        language: repository[:language],
        license: repository.dig(:license)&.slice(:name, :url)
      }
    end
  end

  def populate_error_message(exception)
    context.message = "Invalid Input: #{query}"
    context.technical_message = exception.message
  end

  def empty_response
    {
      total_count: 0,
      items: []
    }
  end
end
