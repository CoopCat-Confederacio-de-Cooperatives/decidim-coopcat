# frozen_string_literal: true

Decidim::DirectVerifications.configure do |config|
  config.input_parser = :metadata_parser
end
