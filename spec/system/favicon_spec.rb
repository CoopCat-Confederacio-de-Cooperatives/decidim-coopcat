# frozen_string_literal: true

require "rails_helper"

describe "Favicon", type: :system do
  context "when the organization has no favicon" do
    let(:organization) { create(:organization, favicon: nil) }

    before do
      switch_to_host(organization.host)
    end

    it "uses the default favicon" do
      visit decidim.root_path
      expect(page).to have_xpath("/html/head/link[contains(@href, 'default_favicon')]", visible: :all)
    end
  end

  context "when the organization has a favicon" do
    let(:organization) { create(:organization) }

    before do
      switch_to_host(organization.host)
    end

    it "uses the organization favicon" do
      visit decidim.root_path
      expect(page).to have_xpath("/html/head/link[contains(@href, 'icon.png')]", visible: :all)
    end
  end
end
