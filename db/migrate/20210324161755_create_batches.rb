class CreateBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :batches do |t|
      t.datetime :finished_at
      t.string :job_id

      t.timestamps
    end
  end
end
