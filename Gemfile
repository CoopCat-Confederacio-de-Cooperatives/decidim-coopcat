# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "0.26.5"

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION

gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator", branch: "develop"
gem "decidim-decidim_awesome"
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "release/0.26-stable"

gem "bootsnap", "~> 1.7"
gem "puma", ">= 5.0.0"

gem "wicked_pdf", "~> 2.1"

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
end

group :production do
  gem "fog-aws"
  gem "sidekiq"
  gem "sidekiq-cron"
end
