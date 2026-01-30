# frozen_string_literal: true

# This migration comes from decidim_action_delegator (originally 20260130133720)
class RemoveNullConstraintFromConsultations < ActiveRecord::Migration[7.2]
  def change
    change_column_null :decidim_action_delegator_settings, :decidim_consultation_id, true
  end
end
