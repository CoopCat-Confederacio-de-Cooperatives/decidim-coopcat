# frozen_string_literal: true
# This migration comes from decidim_action_delegator (originally 20201006084522)

class RemoveSettingIdIndexFromDelegations < ActiveRecord::Migration[5.2]
  def change
    remove_index :decidim_action_delegator_delegations, name: "index_decidim_delegations_on_action_delegator_setting_id"
  end
end
