# frozen_string_literal: true

# Default CarrierWave setup.
#
CarrierWave.configure do |config|
  config.permissions = 0o666
  config.directory_permissions = 0o777
  config.storage = :file
  config.enable_processing = !Rails.env.test?
end

# Although we use Backblaze's B2 as object storage for assets, we use its S3's compatible API. We
# briefly tried the `fog-backblaze` gem but things didn't seem to work at first.
if Rails.application.secrets.dig(:storage, :s3, :access_key_id)
  require "carrierwave/storage/fog"

  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: Rails.application.secrets.dig(:storage, :s3, :access_key_id),
      aws_secret_access_key: Rails.application.secrets.dig(:storage, :s3, :secret_access_key),
      endpoint: Rails.application.secrets.dig(:storage, :s3, :endpoint)
    }
    config.fog_directory = Rails.application.secrets.dig(:storage, :s3, :bucket)
    config.fog_public = true
    config.fog_attributes = {
      "Cache-Control" => "max-age=#{365.days.to_i}",
      "X-Content-Type-Options" => "nosniff"
    }
  end
end
