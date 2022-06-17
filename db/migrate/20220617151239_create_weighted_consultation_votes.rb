class CreateWeightedConsultationVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :weighted_consultation_votes do |t|
      t.datetime :generated_at
      t.integer :consultation_id
      t.integer :question_id
      t.integer :response_id
      t.string :membership_type
      t.integer :membership_weight
      t.boolean :delegated
      t.integer :grantee_id
      t.integer :granter_id

      t.timestamps
    end
  end
end
