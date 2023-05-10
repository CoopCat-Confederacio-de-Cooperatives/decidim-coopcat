# frozen_string_literal: true

require "caprover"

module System
  # Controller to manage Organizations (tenants).
  #
  class CaproverController < Decidim::System::ApplicationController
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

    def index
      Caprover.reset
      render json: Caprover.app_domains
    end

    def enable
      Caprover.add_domain(params[:domain])
      flash[:notice] = "Domini #{params[:domain]} activat correctament"
      redirect_to decidim_system.organizations_path
    end

    def disable
      Caprover.remove_domain(params[:domain])
      flash[:notice] = "Domini #{params[:domain]} desactivat correctament"
      redirect_to decidim_system.organizations_path
    end
  end
end
