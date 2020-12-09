# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.22-stable" }

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION

gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator"
gem "decidim-direct_verifications", github: "Platoniq/decidim-verifications-direct_verifications", branch: "devel"

gem "bootsnap", "~> 1.5"

gem "puma", "~> 4.3.3"
gem "uglifier", "~> 4.1"

gem "faker", "~> 2.15"

group :development, :test do
  gem "byebug", "~> 11.1", platform: :mri

  gem "decidim-dev", "0.22.0"
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.1"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end

group :production do
  gem 'barnes'
  gem 'dalli'
  gem 'fog-aws'
  gem 'lograge'
  gem 'rack-timeout'
  gem 'rails_autoscale_agent'
  gem 'scout_apm'
  gem 'sentry-raven'
  gem 'sidekiq'
end
