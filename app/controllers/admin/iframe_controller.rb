# frozen_string_literal: true

module Admin
  class IframeController < Decidim::Admin::ApplicationController
    def index
      enforce_permission_to :read, :admin_dashboard
    end
  end
end
