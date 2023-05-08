# frozen_string_literal: true

module ApplicationHelper
  def plausible_url
    ENV.fetch("PLAUSIBLE_URL", nil)
  end

  def plausible_code
    ENV.fetch("PLAUSIBLE_#{current_organization.host.gsub(".", "_").upcase}", nil)
  end
end
