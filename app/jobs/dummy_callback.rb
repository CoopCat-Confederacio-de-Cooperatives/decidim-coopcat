class DummyCallback < ApplicationJob
  queue_as :default

  after_perform :tear_down

  def perform(batch_id)
    @batch_id = batch_id

    puts "  => Batch successfully executed"
    puts "  => Notifying user..."
  end

  private

  attr_reader :batch_id

  def tear_down
    update_batch unless batch_finished?
    puts "  => Statuses cleaned up"
  end

  def batch_finished?
    Batch.where(id: batch_id, finished_at: nil).exists?
  end

  def update_batch
    Batch.where(id: batch_id).update_all(finished_at: Time.zone.now)
  end
end
