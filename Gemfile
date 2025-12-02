# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.31-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-action_delegator", github: "openpoke/decidim-module-action_delegator", branch: "main"
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "release/0.31-stable"
gem "decidim-elections", DECIDIM_VERSION
gem "decidim-term_customizer", github: "openpoke/decidim-module-term_customizer", branch: "release/0.31-stable"

gem "bootsnap"
gem "puma"

gem "deface"
gem "health_check"

group :development, :test do
  gem "byebug", "~> 11.1", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "memory_profiler"
  gem "rack-mini-profiler"
  gem "stackprof"
  gem "web-console"
end

group :production do
  gem "aws-sdk-s3", require: false
  gem "sidekiq"
  gem "sidekiq-cron"
end
