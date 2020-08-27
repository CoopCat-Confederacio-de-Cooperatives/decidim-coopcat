# frozen_string_literal: true
# This migration comes from decidim_action_delegator (originally 20200810065755)

class AddOrganizationDelegations < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_action_delegator_delegations,
                  :decidim_organization,
                  foreign_key: true,
                  index: { name: "index_decidim_delegations_on_decidim_organization_id" }
  end
end
