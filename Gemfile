# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", tag: "release/0.22-stable" }

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION

gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator", branch: "feature/decidim-0.22"
gem "decidim-direct_verifications", github: "Platoniq/decidim-verifications-direct_verifications", branch: "devel"

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
end
