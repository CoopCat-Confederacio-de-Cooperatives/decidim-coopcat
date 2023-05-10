# frozen_string_literal: true

require "caprover"
require "plausible"

module System
  # Controller to manage Organizations (tenants).
  #
  class PlausibleController < Decidim::System::ApplicationController
    helper_method :current_organization, :provider_enabled?
    helper Decidim::OmniauthHelper

    rescue_from SystemExit do |exception|
      if request.xhr?
        render json: { error: exception.message }, status: :unprocessable_entity
      else
        flash[:alert] = exception.message
        redirect_to decidim_system.organizations_path
      end
    end

    def enable
      found = Caprover.app_domains.find { |item| item["publicDomain"] == params[:domain] }
      abort("Domain #{params[:domain]} not found") unless found

      result = Plausible.add_domain(params[:domain])

      Caprover.add_env("PLAUSIBLE_#{params[:domain].upcase.gsub(".", "_")}", result["url"].gsub(/.*\?auth=/, "")) if result["url"]

      flash[:notice] = "Stats per #{params[:domain]} activades correctament"
      redirect_to decidim_system.organizations_path
    end
  end
end
