# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  namespace :admin do
    resources :iframe, only: [:index]
  end

  authenticate(:admin) do
    namespace :system do
      resources :caprover, only: [:index] do
        get :enable, on: :collection
        get :disable, on: :collection
      end
      scope :plausible do
        get :enable, to: "plausible#enable"
      end
    end
  end

  mount Decidim::Core::Engine => "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
