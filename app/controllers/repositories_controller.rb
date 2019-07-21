# frozen_string_literal: true

# Manages repositories
class RepositoriesController < ApplicationController
  def index
    action = FetchRepositories.call(permitted_params)
    render render_action_response(action)
  end

  private

  def permitted_params
    params.permit(:query, :sort, :page)
  end

  # Utility method to create consistent responses from interactor action objects
  def render_action_response(action)
    return { json: { data: action.response }, status: :ok } if action.success?

    { json: { message: action.message, technical_message: action.technical_message }, status: :bad_request }
  end
end
