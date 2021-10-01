# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.24-stable" }

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION

gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator", branch: "master"
gem "decidim-direct_verifications", github: "Platoniq/decidim-verifications-direct_verifications", branch: "main"
gem "decidim-decidim_awesome", "~> 0.7.0"
gem "decidim-term_customizer", github: "Platoniq/decidim-module-term_customizer", branch: "temp/0.24"

gem "bootsnap", "~> 1.7"

gem "puma", "~> 5.3.2"
gem "uglifier", "~> 4.1"

group :development, :test do
  gem "byebug", "~> 11.1", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
  gem "faker", "~> 2.18"
end

group :development do
  gem "letter_opener_web", "~> 1.4"
  gem "listen", "~> 3.5"
  gem "spring", "~> 2.1"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
  gem "rack-mini-profiler"
  gem "memory_profiler"
  gem "stackprof"
end

group :production do
  gem 'barnes'
  gem 'dalli'
  gem 'fog-aws'
  gem 'lograge'
  gem 'rack-timeout'
  gem 'scout_apm'
  gem 'sentry-ruby'
  gem 'sentry-rails'
  gem 'sentry-sidekiq'
  gem 'sidekiq'
end
