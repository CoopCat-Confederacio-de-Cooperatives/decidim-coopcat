# frozen_string_literal: true

require "rake"

Rails.application.load_tasks

class MetricsGenerationWorker
  include Sidekiq::Worker

  def perform(*_args)
    Rake::Task["decidim:metrics:all"].invoke
  end
end
