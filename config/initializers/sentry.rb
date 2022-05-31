# frozen_string_literal: true

if Rails.application.secrets.sentry_enabled
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.breadcrumbs_logger = [:active_support_logger, :http_logger, :sentry_logger]
    config.traces_sample_rate = 0.5
  end
end
