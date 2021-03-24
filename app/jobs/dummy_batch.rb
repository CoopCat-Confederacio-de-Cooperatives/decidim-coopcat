# frozen_string_literal: true

class DummyBatch < ApplicationJob
  queue_as :default

  before_perform :persist_batch

  def perform
    2.times do
      DummyJob.perform_later(batch.id)
    end
  end

  private

  attr_reader :batch

  def persist_batch
    puts "  => Persisting batch"
    @batch = Batch.create!(job_id: job_id)
  end
end
