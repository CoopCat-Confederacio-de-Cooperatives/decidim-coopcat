class CreateWeightedConsultationVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :weighted_consultation_votes do |t|
      t.datetime :generated_at

      t.belongs_to :decidim_consultation, index: { name: "index_weighted_consultation_votes_on_consultation" }
      t.belongs_to :decidim_consultation_question, index: { name: "index_weighted_consultation_votes_on_question" }
      t.belongs_to :decidim_consultations_response, index: { name: "index_weighted_consultation_votes_on_response" }
      t.string :membership_type
      t.integer :membership_weight
      t.boolean :delegated
      t.integer :export_number

      t.references :author, foreign_key: { to_table: :decidim_users }
      
      t.references :grantee, foreign_key: { to_table: :decidim_users }
      t.references :granter, foreign_key: { to_table: :decidim_users }

      t.timestamps
    end
  end
end
