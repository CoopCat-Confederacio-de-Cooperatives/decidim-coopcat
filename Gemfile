# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "0.26.4"

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION

gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator", branch: "develop"
gem "decidim-decidim_awesome"
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "release/0.26-stable"

gem "bootsnap", "~> 1.7"

gem "puma", "~> 5.3.2"
gem "uglifier", "~> 4.1"
# bug in version 1.9
gem "i18n", "~> 1.8.1"

group :development, :test do
  gem "byebug", "~> 11.1", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
  gem "faker", "~> 2.18"
  gem "rubocop-faker", "~> 1.0"
end

group :development do
  gem "letter_opener_web"
  gem "listen", "~> 3.5"
  gem "memory_profiler"
  gem "rack-mini-profiler"
  gem "spring", ">= 4.0.0"
  gem "spring-watcher-listen", "~> 2.1"
  gem "stackprof"
  gem "web-console", "~> 4.2"

  gem "capistrano", "~> 3.14"
  gem "capistrano-bundler"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rails-console"
  gem "capistrano-rbenv"
  gem "capistrano-sidekiq"
end

group :production do
  gem "barnes"
  gem "dalli"
  gem "figaro", "~> 1.2"
  gem "fog-aws"
  gem "lograge"
  gem "rack-timeout"
  gem "scout_apm"
  gem "sentry-rails"
  gem "sentry-ruby"
  gem "sentry-sidekiq"
  gem "sidekiq"
  gem "sidekiq-cron"
end
