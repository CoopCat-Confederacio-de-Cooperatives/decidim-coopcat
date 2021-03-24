# frozen_string_literal: true

class DummyJob < ApplicationJob
  queue_as :default

  after_enqueue :persist_job
  after_perform :tear_down

  def perform(batch_id)
    @batch_id = batch_id
  end

  private

  attr_reader :batch_id

  def persist_job
    puts "  => Persisting initial state of job #{job_id}"
    create_job_status
  end

  def tear_down
    puts "  => Persisting end state of job #{job_id}"

    update_job_status
    execute_callback if all_jobs_processed?
  end

  def all_jobs_processed?
    puts "  => #{remaining.count} jobs remaining"
    remaining.count.zero?
  end

  def remaining
    @remaining ||= BackgroundJob.where(status: "enqueued")
  end

  def create_job_status
    BackgroundJob.create(job_id: job_id, batch_id: batch_id, status: "enqueued")
  end

  def update_job_status
    BackgroundJob.where(job_id: job_id).update_all(status: "success")
  end

  def execute_callback
    DummyCallback.perform_later(batch_id)
  end
end
