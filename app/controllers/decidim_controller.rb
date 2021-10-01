# frozen_string_literal: true

# Entry point for Decidim. It will use the `DecidimController` as
# entry point, but you can change what controller it inherits from
# so you can customize some methods.
class DecidimController < ApplicationController
  before_action :set_raven_context

  private

  def set_raven_context
    return unless Rails.application.secrets.sentry_enabled

    Sentry.set_user({ id: try(:current_user).try(:id) }.merge(session))
    Sentry.set_extras(params: params.to_unsafe_h, url: request.url)
  end
end
