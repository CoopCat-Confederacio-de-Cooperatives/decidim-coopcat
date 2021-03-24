class CreateBackgroundJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :background_jobs do |t|
      t.string :status
      t.datetime :finished_at
      t.string :job_id
      t.belongs_to :batch

      t.timestamps
    end
  end
end
