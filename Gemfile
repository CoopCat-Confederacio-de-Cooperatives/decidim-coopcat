# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "openpoke/decidim", branch: "0.31-backports" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-action_delegator", github: "openpoke/decidim-module-action_delegator", branch: "main"
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "main"
gem "decidim-elections", DECIDIM_VERSION
gem "decidim-pokecode", github: "openpoke/decidim-module-pokecode", branch: "main"
gem "decidim-term_customizer", github: "openpoke/decidim-module-term_customizer", branch: "main"

gem "bootsnap", "~> 1.7"
gem "puma", ">= 6.3.1"

gem "deface"

group :development, :test do
  gem "byebug", "~> 11.1", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "memory_profiler"
  gem "web-console"
end
