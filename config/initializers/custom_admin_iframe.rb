# frozen_string_literal: true

Decidim.menu :admin_menu do |menu|
  menu.add_item :custom_iframe,
                "Estadísques web",
                Rails.application.routes.url_helpers.admin_iframe_index_path,
                icon_name: "pie-chart",
                position: 10,
                if: plausible_url.present? && plausible_code.present?
end
