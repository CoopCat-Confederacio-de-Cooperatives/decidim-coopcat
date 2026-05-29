# frozen_string_literal: true

#
# rubocop: disable Security/Eval

namespace :coopcat do
  desc "Export database"
  task :mail_test, [:email]
  task :export_database, [:organization_id] => :environment do |_task, args|
    puts "Going to export the folloding content of the database:"
    puts "- Users from a given organization"
    puts "- Debates from a given organization"
    puts "- Comments from the debates"

    if args.organization_id.nil?
      puts "You have to pass an organization"
      exit
    end

    export_dir = Rails.root.join("tmp/decidim_export")
    FileUtils.mkdir_p export_dir

    export_users(export_dir, organization_id)

    export_debates(export_dir, organization_id)

    export_comments(export_dir, organization_id)
  end

  desc "Import database"
  task :import_database, :organization_id do |_task, args|
    puts "Going to import the folloding models:"
    puts "- Users that have participied in the debates: tmp/decidim_export/users.csv"
    puts "- Debates: tmp/decidim_export/debates.csv"
    puts "- Comments: tmp/decidim_export/comments.csv"

    if args.organization_id.nil?
      puts "You have to pass an organization"
      exit
    end

    import_dir = Rails.root.join("tmp/decidim_export")

    import_users(import_dir, organization_id)

    import_debates(import_dir, organization_id)

    import_comments(import_dir, organization_id)
  end

  desc "Import Comments"
  task :import_comments, [:organization_id] => :environment do |_task, args|
    import_dir = Rails.root.join("tmp/decidim_export")

    import_comments(import_dir, args.organization_id)
  end

  desc "Import Debates"
  task :import_debates, [:organization_id] => :environment do |_task, args|
    import_dir = Rails.root.join("tmp/decidim_export")

    import_debates(import_dir, args.organization_id)
  end

  desc "Import Users"
  task :import_users, [:organization_id] => :environment do |_task, args|
    import_dir = Rails.root.join("tmp/decidim_export")

    import_users(import_dir, args.organization_id)
  end

  desc "Export Debates"
  task :export_debates, [:organization_id] => :environment do |_task, args|
    export_dir = Rails.root.join("tmp/decidim_export")

    export_debates(export_dir, args.organization_id)
  end

  desc "Export Users"
  task :export_users, [:organization_id] => :environment do |_task, args|
    export_dir = Rails.root.join("tmp/decidim_export")

    export_users(export_dir, args.organization_id)
  end

  desc "Export Comments"
  task :export_comments, [:organization_id] => :environment do |_task, args|
    export_dir = Rails.root.join("tmp/decidim_export")

    export_comments(export_dir, args.organization_id)
  end

  def export_debates(export_dir, _organization_id)
    path = export_dir.join("debates.csv")

    debates = Decidim::Debates::Debate.all
    puts "Exporting debates"

    count = 0
    CSV.open(path, "wb") do |csv|
      csv << (Decidim::Debates::Debate.attribute_names + %w(component_name space_slug space_type author_email))

      debates.each do |debate|
        next unless debate.component.participatory_space.slug.in? all_slugs

        component_name = debate.component.name["ca"]
        space_slug = debate.component.participatory_space.slug
        space_type = debate.component.participatory_space.class.name
        author_email = debate.author.email if debate.decidim_author_type == Decidim::UserBaseEntity.name
        csv << (debate.attributes.values + [component_name, space_slug, space_type, author_email])
        count += 1
      end
    end

    puts "Exported #{count} debates. You can find them in #{path}"
  end

  def export_comments(export_dir, _organization_id)
    path = export_dir.join("comments.csv")

    slugs = all_slugs
    count = 0

    CSV.open(path, "wb") do |csv|
      csv << (Decidim::Comments::Comment.attribute_names + %w(space_slug author_email commentable_type commentable_id component_title))

      comments = Decidim::Comments::Comment.where.not("decidim_commentable_type like ?", "%Decidim::Consultations%").includes(:author, commentable: :participatory_space)

      comments.each do |comment|
        commentable = comment.commentable

        next if commentable.respond_to?(:commentable) && commentable.decidim_commentable_type.include?("Decidim::Consultations")
        next if commentable.respond_to?(:decidim_root_commentable_type) && commentable.decidim_root_commentable_type.include?("Decidim::Consultations")

        space = comment.commentable.try(:participatory_space)
        title = comment.commentable.try(:title)
        title_ca = title["ca"] unless title.nil?

        commentable_type = comment.decidim_commentable_type
        commentable_id = comment.decidim_commentable_id
        next unless space&.slug.in?(slugs)

        csv << (comment.attributes.values + [space.slug, comment.author.email, commentable_type, commentable_id, title_ca]) if space&.slug.in?(slugs)

        count += 1
      end

      puts "Exported #{count} comments. You can find them in #{path}"
    end
  end

  def export_users(export_dir, _organization_id)
    path = export_dir.join("users.csv")
    slugs = all_slugs
    users = []

    comments = Decidim::Comments::Comment.where.not("decidim_commentable_type like ?", "%Decidim::Consultations%").includes(commentable: :participatory_space)

    comments.each do |comment|
      next unless comment.respond_to?(:commentable)

      commentable = comment.commentable

      next if commentable.respond_to?(:commentable) && commentable.decidim_commentable_type.include?("Decidim::Consultations")
      next if commentable.respond_to?(:decidim_root_commentable_type) && commentable.decidim_root_commentable_type.include?("Decidim::Consultations")

      begin
        space = commentable&.try(:participatory_space)
      rescue StandardError
      end
      users << comment.author if space&.slug.in?(slugs)
    end

    debates = Decidim::Debates::Debate.all
    debates.each do |debate|
      space = debate.participatory_space
      author = debate.author
      users << author if debate.decidim_author_type == Decidim::UserBaseEntity.name && space&.slug.in?(slugs)
    end

    users.uniq!

    puts "Exporting users: #{users.count}"

    CSV.open(path, "wb") do |csv|
      csv << Decidim::User.attribute_names
      users.each do |user|
        csv << user.attributes.values
      end
    end

    puts "Done exporting users. You can find them in #{path}"
  end

  def import_users(import_dir, organization_id)
    path = import_dir.join("users.csv")

    organization = Decidim::Organization.find(organization_id)

    csv = CSV.parse(File.read(path), headers: true)
    puts "Importing users: #{csv.length}"
    count = 0
    already_exists = 0

    csv.each do |row|
      exists_user = Decidim::User.where("email = :email OR nickname = :nickname", email: row["email"], nickname: row["nickname"])

      if exists_user.empty?
        user = Decidim::User.new(name: row["name"], email: row["email"], accepted_tos_version: Time.current, nickname: row["nickname"],
                                 organization: organization)
      end

      unless user
        already_exists += 1
        next
      end

      user.skip_invitation = true
      user.invite!
      user.save
      count += 1
    end

    puts "Done importing users: #{count} - #{already_exists} already existed"
  end

  def import_comments(import_dir, _organization_id)
    path = import_dir.join("comments.csv")

    csv = CSV.parse(File.read(path), headers: true)
    count = 0
    could_not_import = 0

    new_ids = []

    csv.each do |row|
      row["space_slug"]
      author_email = row["author_email"]
      row["component_title"]
      commentable_type = row["commentable_type"]
      commentable_id = row["commentable_id"]

      row.delete("space_slug")
      row.delete("author_email")
      row.delete("component_title")
      row.delete("commentable_type")
      row.delete("commentable_id")

      begin
        if commentable_type == "Decidim::Comments::Comment"
          new_id = new_ids[commentable_id.to_i]
          if new_id.nil?
            Decidim::Comments::Comment.find("body ->> 'ca' = ?", row["body"])
          else
            commentable = Decidim::Comments::Comment.find(new_ids[commentable_id.to_i])
          end
        else
          commentable = commentable_type.constantize.find(commentable_id)
        end
      rescue StandardError => e
        puts "Could not find commentable #{commentable_type} #{commentable_id}"
        puts e
        could_not_import += 1
        next
      end

      author = Decidim::User.find_by(email: author_email)

      id = row["id"]
      row.delete("id")

      comment = Decidim::Comments::Comment.new(row.to_hash)
      comment.body = eval(row["body"])
      comment.author = author
      comment.commentable = commentable
      root_commentable = if commentable_type == "Decidim::Comments::Comment"
                           commentable.commentable
                         else
                           commentable
                         end
      comment.root_commentable = root_commentable
      begin
        comment.save!
        count += 1
        new_ids[id.to_i] = comment.id
      rescue StandardError => e
        puts "Could not import comment #{comment.id}"
        could_not_import += 1
        puts e
      end
    end

    puts "Imported #{count} comments. Could not import #{could_not_import}"
  end

  def import_debates(import_dir, organization_id)
    path = import_dir.join("debates.csv")

    csv = CSV.parse(File.read(path), headers: true)
    imported = 0
    could_not_import = 0

    puts "Importing debates"
    csv.each do |row|
      space_slug = row["space_slug"]
      space_type = row["space_type"]
      space = space_type.constantize.find_by(slug: space_slug)

      component_name = row["component_name"]
      component = Decidim::Component.where("name ->> 'ca' = ?", component_name).where(participatory_space: space).first
      puts "could not find component with name #{component_name}" unless component

      unless component
        could_not_import += 1
        next
      end

      row.delete("component_name")
      row.delete("space_slug")
      row.delete("space_type")

      author_email = row["author_email"]
      row.delete("author_email")

      debate = Decidim::Debates::Debate.new(row.to_hash)
      debate.component = component
      debate.title = eval(row["title"])
      debate.description = eval(row["description"])
      debate.instructions = eval(row["instructions"]) if row["instructions"].present?
      debate.information_updates = eval(row["information_updates"]) if row["information_updates"].present?

      author = Decidim::Organization.find(organization_id) if author_email.blank?
      author = Decidim::User.find_by(email: author_email) if author_email.present?
      debate.author = author

      begin
        unless debate.save
          puts "Could not import debate. #{debate.id} - #{debate.title}"
          could_not_import += 1
          puts debate.errors.full_messages
          next
        end
      rescue StandardError => e
        puts "Could not import debate. #{debate.id} - #{debate.title}"
        could_not_import += 1
        puts e
        next
      end

      imported += 1
    end

    puts "Imported #{imported} debates. Could not import #{could_not_import}"
  end

  def all_slugs
    %w(debatsocies)
  end

  # rubocop: enable Security/Eval
end
