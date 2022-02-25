# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "Platoniq/decidim", branch: "temp/0.24" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION

gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator", branch: "master"
gem "decidim-decidim_awesome", "~> 0.7.0"
gem "decidim-direct_verifications", github: "Platoniq/decidim-verifications-direct_verifications", branch: "main"
gem "decidim-term_customizer", github: "Platoniq/decidim-module-term_customizer", branch: "temp/0.24"

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
  gem "letter_opener_web", "~> 1.4"
  gem "listen", "~> 3.5"
  gem "memory_profiler"
  gem "rack-mini-profiler"
  gem "spring", "~> 2.1"
  gem "spring-watcher-listen", "~> 2.0"
  gem "stackprof"
  gem "web-console", "~> 3.5"

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
