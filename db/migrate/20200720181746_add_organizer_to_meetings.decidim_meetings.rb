# frozen_string_literal: true

# This migration comes from decidim_meetings (originally 20180404075312)
# This file has been modified by `decidim upgrade:migrations` task on 2025-11-25 09:35:07 UTC
class AddOrganizerToMeetings < ActiveRecord::Migration[5.1]
  def change
    add_reference :decidim_meetings_meetings, :organizer, index: true
  end
end
