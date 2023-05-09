# frozen_string_literal: true

require "caprover"
namespace :caprover do
  task :info, :environment do |_task|
    puts Caprover.info
  end

  task :app_data, :environment do |_task|
    puts Caprover.app_data
  end

  task :app_info, :environment do |_task|
    puts JSON.pretty_generate(Caprover.app_info)
  end

  task :app_domains, :environment do |_task|
    puts JSON.pretty_generate(Caprover.app_domains)
  end

  task :app_env, :environment do |_task|
    puts JSON.pretty_generate(Caprover.app_env)
  end

  desc "adds an ENV var"
  task :add_env, [:key, :value] => :environment do |_task, args|
    raise ArgumentError if args.key.blank?

    puts JSON.pretty_generate(Caprover.add_env(args.key, args.value.to_s))
  end

  desc "adds a domain and enable ssl"
  task :add_domain, [:domain] => :environment do |_task, args|
    raise ArgumentError if args.domain.blank?

    puts Caprover.add_domain args.domain
  end

  desc "removes a domain"
  task :remove_domain, [:domain] => :environment do |_task, args|
    raise ArgumentError if args.domain.blank?

    puts Caprover.remove_domain args.domain
  end
end
