# frozen_string_literal: true
# This migration comes from decidim_action_delegator (originally 20201030164808)

class AddDelegationIdToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :decidim_action_delegator_delegation_id, :integer, null: true, default: nil
    add_index :versions, :decidim_action_delegator_delegation_id
  end
end
