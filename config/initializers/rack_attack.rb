# frozen_string_literal: true

if Rails.env.production?
  Decidim.configure do |config|
    # Max requests in a time period to prevent DoS attacks. Only applied on production.
    config.throttling_max_requests = 100

    # Time window in which the throttling is applied.
    config.throttling_period = 1.minute
  end

  # require "rack/attack"
  # Rails.application.configure do |config|
  #   config.middleware.use Rack::Attack
  # end
  # Rack::Attack.throttle(
  #   "requests by ip",
  #   limit: 1,
  #   period: 1.minute,
  #   &:ip
  # )

  # Provided that trusted users use an HTTP request param named skip_rack_attack
  Rack::Attack.safelist("mark any authenticated access safe") do |request|
    # Requests are allowed if the return value is truthy
    skip = Rails.application.secrets.rack_attack_skip || "let-me-hack"
    request.params["skip_rack_attack"] == skip
  end
end
