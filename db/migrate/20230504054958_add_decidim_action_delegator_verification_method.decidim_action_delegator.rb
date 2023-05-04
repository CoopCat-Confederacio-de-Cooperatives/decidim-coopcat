# frozen_string_literal: true
# This migration comes from decidim_action_delegator (originally 20230323223752)

class AddDecidimActionDelegatorVerificationMethod < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_action_delegator_settings, :authorization_method, :integer, default: 0, null: false
  end
end
