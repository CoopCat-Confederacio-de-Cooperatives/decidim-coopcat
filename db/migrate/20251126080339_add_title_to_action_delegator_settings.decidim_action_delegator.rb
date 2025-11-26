# frozen_string_literal: true
# This migration comes from decidim_action_delegator (originally 20250729104037)
class AddTitleToActionDelegatorSettings < ActiveRecord::Migration[7.2]
  class Setting < ApplicationRecord
    self.table_name = :decidim_action_delegator_settings
  end

  def up
    add_column :decidim_action_delegator_settings, :title, :jsonb
    add_column :decidim_action_delegator_settings, :description, :jsonb
    add_column :decidim_action_delegator_settings, :active, :boolean, default: false, null: false
    add_reference :decidim_action_delegator_settings, :decidim_organization, foreign_key: { to_table: :decidim_organizations }

    if ActiveRecord::Base.connection.table_exists? "decidim_consultations"
      Setting.find_each do |setting|
        consultation = ActiveRecord::Base.connection.execute("SELECT * FROM decidim_consultations WHERE id = #{setting.decidim_consultation_id}").first
        next unless consultation

        setting.update!(title: JSON.parse(consultation["title"]), decidim_organization_id: consultation["decidim_organization_id"])
      end
    end

    change_column_null :decidim_action_delegator_settings, :decidim_organization_id, false
  end

  def down
    remove_column :decidim_action_delegator_settings, :title
    remove_column :decidim_action_delegator_settings, :description
    remove_reference :decidim_action_delegator_settings, :decidim_organization, index: true, foreign_key: { to_table: :decidim_organizations }
    remove_column :decidim_action_delegator_settings, :active
  end
end
