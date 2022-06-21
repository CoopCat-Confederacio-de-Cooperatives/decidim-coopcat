# frozen_string_literal: true

class WeightedConsultationVote < ApplicationRecord
  belongs_to :consultation, class_name: "Decidim::Consultation", foreign_key: "decidim_consultation_id"
  belongs_to :question, class_name: "Decidim::Consultations::Question", foreign_key: "decidim_consultation_question_id"
  belongs_to :response, class_name: "Decidim::Consultations::Response", foreign_key: "decidim_consultations_response_id"
end
