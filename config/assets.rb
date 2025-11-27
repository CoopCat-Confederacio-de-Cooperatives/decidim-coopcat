# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Shakapacker.register_path("#{base_path}/app/packs")
Decidim::Shakapacker.register_entrypoints(
  caprover_system: "#{base_path}/app/packs/entrypoints/caprover_system.js"
)
