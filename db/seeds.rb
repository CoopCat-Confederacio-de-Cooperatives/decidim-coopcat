# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# You can remove the 'faker' gem if you don't want Decidim seeds.
if ENV["HEROKU_APP_NAME"].present?
  ENV["DECIDIM_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"
  ENV["SEED"] = "true"
end

require "decidim/faker/localized"

Decidim::Organization.first || Decidim::Organization.create!(
  name: Faker::Company.name,
  twitter_handler: Faker::Hipster.word,
  facebook_handler: Faker::Hipster.word,
  instagram_handler: Faker::Hipster.word,
  youtube_handler: Faker::Hipster.word,
  github_handler: Faker::Hipster.word,
  smtp_settings: {
    from: ENV["EMAIL"],
    user_name: ENV["SENDGRID_USERNAME"],
    encrypted_password: Decidim::AttributeEncryptor.encrypt(ENV["SENDGRID_PASSWORD"]),
    address: "smtp.sendgrid.net",
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  },
  host: ENV["DECIDIM_HOST"] || "localhost",
  description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
    Decidim::Faker::Localized.sentence(15)
  end,
  default_locale: Decidim.default_locale,
  available_locales: Decidim.available_locales,
  reference_prefix: Faker::Name.suffix,
  available_authorizations: Decidim.authorization_workflows.map(&:name),
  users_registration_mode: :enabled,
  tos_version: Time.current,
  badges_enabled: true,
  user_groups_enabled: true,
  send_welcome_notification: true
)

Decidim.seed!
