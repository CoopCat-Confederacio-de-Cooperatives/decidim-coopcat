starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)

CONSULTATION_SLUG = "AGO2022"

DEFAULT_METADATA = { membership_type: "none", membership_weight: "1" }

def metadata(decidim_user_id)
  authorization = Decidim::Authorization.find_by(name: "direct_verifications", decidim_user_id: decidim_user_id)
  user_metadata = authorization&.metadata || {}
  {
    membership_type: user_metadata["membership_type"] || DEFAULT_METADATA[:membership_type],
    membership_weight: user_metadata["membership_weight"] || DEFAULT_METADATA[:membership_weight]
  }
end

def query(consultation)
  statement = <<-SQL.squish
    SELECT decidim_action_delegator_delegations.granter_id, decidim_action_delegator_delegations.grantee_id, versions.item_type, versions.item_id
    FROM versions
    INNER JOIN decidim_action_delegator_delegations
      ON decidim_action_delegator_delegations.id = versions.decidim_action_delegator_delegation_id
    INNER JOIN decidim_action_delegator_settings
      ON decidim_action_delegator_settings.id = decidim_action_delegator_delegations.decidim_action_delegator_setting_id
    WHERE decidim_action_delegator_settings.decidim_consultation_id = #{consultation.id}
  SQL

  ActiveRecord::Base.connection.execute(statement).to_a
end




consultation = Decidim::Consultation.find_by slug: CONSULTATION_SLUG

question_ids = consultation.questions.pluck(:id)
users_who_voted_ids = Decidim::Consultations::Vote.where(question: question_ids).pluck(:decidim_author_id).uniq

users_who_voted_metadata = {}

authorizations = Decidim::Authorization.where(name: "direct_verifications", decidim_user_id: users_who_voted_ids)
authorizations.find_each do |authorization|
  users_who_voted_metadata[authorization.decidim_user_id] = {
    membership_type: authorization.metadata["membership_type"] || "none",
    membership_weight: authorization.metadata["membership_weight"] || "1"
  }
end

granters_by_vote_id = {}

File.open("consultation_info.txt", 'w') do |file|
  query(consultation).each do |record|
    granters_by_vote_id[record["item_id"]] = record["granter_id"]

    file.write record
    file.write "\n"
  end
end

File.open("consultation_results.csv", 'w') do |file|
  file.write "consultation_id, question_id, response_id, membership_weight, membership_type, delegated\n"
  
  Decidim::Consultations::Vote.where(question: question_ids).find_each do |vote|
    delegated = false
    user_metadata = users_who_voted_metadata[vote.author.id] || DEFAULT_METADATA

    author_id = vote.author.id

    if granters_by_vote_id[vote.id]
      author_id = granters_by_vote_id[vote.id]

      delegated = true
      user_metadata = metadata(author_id)
    end

    file.write "#{consultation.id}, #{vote.question.id}, #{vote.response.id}, #{user_metadata[:membership_weight]}, #{user_metadata[:membership_type]}, #{delegated}\n"
  end
end

# time consuming operation
ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
elapsed = ending - starting
elapsed # => 9.183449000120163 seconds

puts "#{elapsed} seconds"
puts "#{elapsed / 60.0} minutes"

File.open("consultation_stats.txt", 'w') do |file|
  file.write "TOTAL USERS: #{users_who_voted_ids.count} \n"
  file.write "TOTAL VOTES: #{Decidim::Consultations::Vote.where(question: question_ids).count} \n"
  file.write "Time elapsed: #{elapsed} seconds \n"
end