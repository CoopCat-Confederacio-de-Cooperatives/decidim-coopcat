# frozen_string_literal: true
# This migration comes from decidim_action_delegator (originally 20230323101247)

class CreateDecidimActionDelegatorPonderations < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_action_delegator_ponderations do |t|
      t.references :decidim_action_delegator_setting, null: false, index: { name: "index_decidim_action_delegator_ponderations_on_setting_id" }
      t.string :name, null: false
      t.decimal :weight, null: false, default: 1, precision: 5, scale: 2
      t.timestamps
    end
  end
end
