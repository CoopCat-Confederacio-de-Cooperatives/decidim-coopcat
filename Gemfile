# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.29-stable" }.freeze

gem "decidim", DECIDIM_VERSION
# gem "decidim-consultations", DECIDIM_VERSION

gem "nokogiri", "< 1.18.2"

# gem "decidim-action_delegator", github: "openpoke/decidim-module-action_delegator", branch: "release/0.28-stable"
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "release/0.29-stable"
gem "decidim-term_customizer", github: "openpoke/decidim-module-term_customizer", branch: "release/0.29-stable"

gem "bootsnap", "~> 1.7"
gem "puma", ">= 5.0.0"
gem "grover", "~> 1.1"

gem "deface"
gem "faraday"

group :development, :test do
  gem "byebug", "~> 11.1", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
  gem "faker", "~> 3.2"
  gem "rubocop-faker", "~> 1.0"
end

group :development do
  gem "letter_opener_web"
  gem "listen", "~> 3.5"
  gem "memory_profiler"
  gem "rack-mini-profiler"
  gem "stackprof"
  gem "web-console", "~> 4.2"
end

group :production do
  gem "aws-sdk-s3", require: false
  gem "sidekiq"
  gem "sidekiq-cron"
end
