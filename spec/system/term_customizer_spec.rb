# frozen_string_literal: true

require "rails_helper"

describe "Term customizer", type: :system do
  let(:organization) { create(:organization) }
  let!(:user) do
    create(:user, :admin, :confirmed,
           organization: organization,
           nickname: "admin") # Else it gives "Nickname is too long" error
  end

  before do
    switch_to_host(organization.host)
    sign_in user
  end

  it "allows visiting the admin page for Term Customizer" do
    visit decidim_admin.root_path
    expect(page).to have_link "Term customizer", href: "#{decidim_admin.root_path}term_customizer/sets"
  end
end
