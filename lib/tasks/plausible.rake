# frozen_string_literal: true

require "plausible"
require "caprover"
namespace :plausible do
  task :info, [:domain] => :environment do |_task, args|
    raise ArgumentError if args.domain.blank?

    puts JSON.pretty_generate(Plausible.info(args.domain))
  end

  task :add_domain, [:domain] => :environment do |_task, args|
    raise ArgumentError if args.domain.blank?

    result = Plausible.add_domain(args.domain)

    Caprover.add_env("PLAUSIBLE_#{args.domain.upcase.gsub(".", "_")}", result["url"].gsub(/.*\?auth=/, "")) if result["url"]

    puts JSON.pretty_generate(result)
  end
end
