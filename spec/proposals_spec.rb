# frozen_string_literal: true

require "rails_helper"

describe "Visit a proposal", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:proposals_component) { create :component, manifest_name: :proposals, participatory_space: participatory_process }
  let!(:proposal) { create :proposal, component: proposals_component }
  let!(:awesome_config) { create :awesome_config, organization: organization, var: :use_markdown_editor, value: true }

  before do
    switch_to_host(organization.host)
    # page.visit main_component_path(proposals_component)
    # execute_script("window.DecidimAwesome.use_markdown_editor = true;")
    page.visit main_component_path(proposals_component)
    click_link proposal.title["en"]
  end

  it "allows viewing a single proposal" do
    expect(page).to have_content(proposal.title["en"])
    expect(page).to have_content(strip_tags(proposal.body["en"]).strip)
  end

  context "when has markdown" do
    let!(:proposal) { create :proposal, :official, body: "## title\n\n**bold**", component: proposals_component }

    it "is a official proposal" do
      expect(proposal.official?).to eq(true)
    end

    it "renders markdown" do
      expect(page).to have_content(proposal.title["en"])
      expect(page.html).to include("<h2>title</h2>")
      expect(page.html).to include("<strong>bold</strong>")
    end
  end
end
