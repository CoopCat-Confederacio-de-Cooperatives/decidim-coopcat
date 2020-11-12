# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "coopdevs/decidim", branch: "fix/consultation-description-rich-text" }

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION

gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator"
gem "decidim-direct_verifications", github: "coopdevs/decidim-verifications-direct_verifications", branch: "feature/decidim-0.22"

gem "bootsnap", "~> 1.3"

gem "puma", "~> 4.3.3"
gem "rack-timeout"
gem "uglifier", "~> 4.1"

gem "faker", "~> 1.9"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", "0.22.0"
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end

group :production do
  gem 'dalli'
  gem 'fog-aws'
  gem 'lograge'
  gem 'sentry-raven'
  gem 'sidekiq'
  gem 'barnes'
end
