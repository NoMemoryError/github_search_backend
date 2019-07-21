# frozen_string_literal: true

# Allows the clients to determine whether the app is up
class HealthController < ApplicationController
  def status
    render json: { time: Time.now.iso8601, status: :healthy }
  end
end
