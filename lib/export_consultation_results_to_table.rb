# frozen_string_literal: true

class ExportConsultationResultsToTable
  DEFAULT_METADATA = { membership_type: nil, membership_weight: nil }.freeze

  def initialize(consultation)
    @consultation = consultation
    @question_ids = @consultation.questions.pluck(:id)
    users_who_voted_ids = Decidim::Consultations::Vote.where(question: @question_ids).pluck(:decidim_author_id).uniq

    @users_who_voted_metadata = {}
    @grantees_by_vote_id = {}

    # Store metadata for users who voted
    authorizations = Decidim::Authorization.where(name: "direct_verifications", decidim_user_id: users_who_voted_ids)
    authorizations.find_each do |authorization|
      @users_who_voted_metadata[authorization.decidim_user_id] = {
        membership_type: authorization.metadata["membership_type"] || "none",
        membership_weight: authorization.metadata["membership_weight"] || "1"
      }
    end

    # Store delegation granter for each vote
    granted_votes_query.each do |record|
      @grantees_by_vote_id[record["item_id"]] = record["grantee_id"]
    end
  end

  def export_results!
    @records = []

    @generated_at = Time.zone.now
    @export_number = WeightedConsultationVote.distinct(:export_number).pluck(:export_number).max || 0
    @export_number += 1

    Decidim::Consultations::Vote.where(question: @question_ids).find_each do |vote|
      delegated = false
      user_metadata = @users_who_voted_metadata[vote.author.id] || DEFAULT_METADATA

      if @grantees_by_vote_id[vote.id]
        grantee_id = @grantees_by_vote_id[vote.id]

        delegated = true
      end

      attributes = {
        decidim_consultation_id: @consultation.id,
        decidim_consultation_question_id: vote.question.id,
        decidim_consultations_response_id: vote.response.id,
        delegated: delegated,
        author_id: vote.author.id,
        granter_id: vote.author.id,
        grantee_id: grantee_id,
        generated_at: @generated_at,
        export_number: @export_number
      }.merge(user_metadata)

      WeightedConsultationVote.create(attributes)
    end

    @records
  end

  def metadata(decidim_user_id)
    authorization = Decidim::Authorization.find_by(name: "direct_verifications", decidim_user_id: decidim_user_id)
    user_metadata = authorization&.metadata || {}
    {
      membership_type: user_metadata["membership_type"] || DEFAULT_METADATA[:membership_type],
      membership_weight: user_metadata["membership_weight"] || DEFAULT_METADATA[:membership_weight]
    }
  end

  def granted_votes_query
    statement = <<-SQL.squish
      SELECT decidim_action_delegator_delegations.granter_id, decidim_action_delegator_delegations.grantee_id, versions.item_type, versions.item_id
      FROM versions
      INNER JOIN decidim_action_delegator_delegations
        ON decidim_action_delegator_delegations.id = versions.decidim_action_delegator_delegation_id
      INNER JOIN decidim_action_delegator_settings
        ON decidim_action_delegator_settings.id = decidim_action_delegator_delegations.decidim_action_delegator_setting_id
      WHERE decidim_action_delegator_settings.decidim_consultation_id = #{@consultation.id}
    SQL

    ActiveRecord::Base.connection.execute(statement).to_a
  end
end
