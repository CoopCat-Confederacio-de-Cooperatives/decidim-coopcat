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
CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {
    provider: 'backblaze',
    b2_key_id: Rails.application.secrets.backblaze.access_key_id,
    b2_key_token: Rails.application.secrets.backblaze.secret_access_key
  }
  config.fog_directory  = 'cercles-coop-production'
  config.fog_public     = true
  config.fog_attributes = {
    'Cache-Control' => "max-age=#{365.day.to_i}",
    'X-Content-Type-Options' => "nosniff"
  }
end
