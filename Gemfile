# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "0.21.0"
gem "decidim-consultations", "0.21.0"
# gem "decidim-initiatives", "0.21.0"

gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator"

gem "bootsnap", "~> 1.3"

gem "puma", "~> 4.3.3"
gem "uglifier", "~> 4.1"

gem "faker", "~> 1.9"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", "0.21.0"
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"

  gem "decidim-deploy-heroku", git: "https://github.com/codegram/decidim-deploy-heroku.git"
end

group :production do
  gem 'passenger'
  gem 'fog-aws'
  gem 'dalli'
  gem 'sendgrid-ruby'
  gem 'newrelic_rpm'
  gem 'lograge'
  gem 'sentry-raven'
  gem 'sidekiq'
end