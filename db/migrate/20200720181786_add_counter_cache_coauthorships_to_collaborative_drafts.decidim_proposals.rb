# frozen_string_literal: true

# This migration comes from decidim_proposals (originally 20180711074134)
# This file has been modified by `decidim upgrade:migrations` task on 2025-11-25 09:35:08 UTC
class AddCounterCacheCoauthorshipsToCollaborativeDrafts < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_proposals_collaborative_drafts, :coauthorships_count, :integer, null: false, default: 0
  end
end
