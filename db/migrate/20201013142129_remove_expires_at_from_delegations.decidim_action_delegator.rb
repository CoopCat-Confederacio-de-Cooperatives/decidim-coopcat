# frozen_string_literal: true
# This migration comes from decidim_action_delegator (originally 20201001172345)

class RemoveExpiresAtFromDelegations < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_action_delegator_settings, :expires_at
  end
end
