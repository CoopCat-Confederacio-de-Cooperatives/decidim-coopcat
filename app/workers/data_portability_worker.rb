# frozen_string_literal: true

require "rake"

Rails.application.load_tasks

class DataPortabilityWorker
  include Sidekiq::Worker

  def perform(*_args)
    Rake::Task["decidim:delete_data_portability_files"].invoke
    Rake::Task["decidim:open_data:export"].invoke
  end
end
