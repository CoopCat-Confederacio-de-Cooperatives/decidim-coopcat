# frozen_string_literal: true

# This migration comes from decidim_meetings (originally 20210430123416)
# This file has been modified by `decidim upgrade:migrations` task on 2025-11-25 09:35:07 UTC
class AddPublicParticipationToDecidimMeetingsRegistrations < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_meetings_registrations, :public_participation, :boolean, default: false
  end
end
