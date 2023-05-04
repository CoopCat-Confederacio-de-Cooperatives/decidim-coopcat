# frozen_string_literal: true
# This migration comes from decidim_action_delegator (originally 20230323210000)

class CreateDecidimActionDelegatorParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_action_delegator_participants do |t|
      t.references :decidim_action_delegator_setting, null: false, index: { name: "index_decidim_action_delegator_participants_on_setting_id" }
      t.references :decidim_action_delegator_ponderation, index: { name: "index_decidim_action_delegator_participants_on_ponderation_id" }
      t.string :email, null: false
      t.string :phone
      t.timestamps
    end
  end
end
