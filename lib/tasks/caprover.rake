# frozen_string_literal: true

require "caprover"
namespace :caprover do
  desc "add domain and enable ssl"
  task :info, :environment do |_task|
    Caprover.info
  end

  task :app_data, :environment do |_task|
    Caprover.app_data
  end

  task :add_domain, [:domain] => :environment do |_task, args|
    raise ArgumentError if args.domain.blank?

    Caprover.add_domain args.domain
  end

  task :remove_domain, [:domain] => :environment do |_task, args|
    raise ArgumentError if args.domain.blank?

    Caprover.remove_domain args.domain
  end
end
