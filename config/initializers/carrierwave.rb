# frozen_string_literal: true

# Default CarrierWave setup.
#
CarrierWave.configure do |config|
  config.permissions = 0o666
  config.directory_permissions = 0o777
  config.storage = :file
  config.enable_processing = !Rails.env.test?
end

# Needs the "fog-backblaze" gem.
#
if Rails.application.secrets.backblaze[:access_key_id].present?
  require "carrierwave/storage/fog"

  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.secrets.backblaze[:access_key_id],
      aws_secret_access_key: Rails.application.secrets.backblaze[:secret_access_key],
      endpoint: 'https://s3.us-west-001.backblazeb2.com'
    }
    config.fog_directory  = 'cercles-coop-production'
    config.fog_public     = true
    config.fog_attributes = {
      'Cache-Control' => "max-age=#{365.day.to_i}",
      'X-Content-Type-Options' => "nosniff"
    }
  end
end
