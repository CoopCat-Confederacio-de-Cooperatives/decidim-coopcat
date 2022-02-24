# frozen_string_literal: true

# initializers/sidekiq.rb

if Rails.env.production?

  schedule_file = "config/schedule.yml"

  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file) && Sidekiq.server?
end
