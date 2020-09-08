# frozen_string_literal: true
# This migration comes from decidim_action_delegator (originally 20200828113755)

class AddSettingIdToDelegations < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :decidim_action_delegator_delegations,
                   :decidim_action_delegator_setting,
                   null: false,
                   foreign_key: true,
                   index: { name: "index_decidim_delegations_on_action_delegator_setting_id" }
  end
end
