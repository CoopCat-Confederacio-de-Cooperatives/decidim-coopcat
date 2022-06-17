# frozen_string_literal: true
require "export_consultation_results_to_table"

module Decidim
  class ExportConsultationResultsToTableJob < ApplicationJob
    queue_as :default

    def perform(user, consultation_slug)
      @consultation_slug = consultation_slug
      
      ExportConsultationResultsToTable.new(consultation).export_results!
    end

    private

    def consultation
      Decidim::Consultation.find_by(slug: @consultation_slug)
    end
  end
end
