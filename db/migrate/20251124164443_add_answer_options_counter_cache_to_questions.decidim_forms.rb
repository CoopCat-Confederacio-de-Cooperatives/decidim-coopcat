# frozen_string_literal: true

# This migration comes from decidim_forms (originally 20240402092039)
# This file has been modified by `decidim upgrade:migrations` task on 2026-01-30 13:27:21 UTC
class AddAnswerOptionsCounterCacheToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_forms_questions, :answer_options_count, :integer, null: false, default: 0

    reversible do |dir|
      dir.up do
        Decidim::Forms::Question.reset_column_information
        Decidim::Forms::Question.find_each do |record|
          record.class.reset_counters(record.id, :answer_options)
        end
      end
    end
  end
end
