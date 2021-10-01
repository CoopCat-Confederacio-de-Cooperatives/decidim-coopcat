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
if Rails.application.secrets.dig(:backblaze, :access_key_id).present?
  require "carrierwave/storage/fog"

  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: Rails.application.secrets.backblaze[:access_key_id],
      aws_secret_access_key: Rails.application.secrets.backblaze[:secret_access_key],
      endpoint: "https://s3.us-west-001.backblazeb2.com"
    }
    config.fog_directory = Rails.application.secrets.backblaze[:bucket_name]
    config.fog_public = true
    config.fog_attributes = {
      "Cache-Control" => "max-age=#{365.days.to_i}",
      "X-Content-Type-Options" => "nosniff"
    }
  end
end
