# frozen_string_literal: true

require "rails_helper"

RSpec.describe VerticalNavbarComponent, type: :component do
  let(:user) { users(:terry_medhurst) }

  context "when rendered in specific url without options" do
    it "renders url as active tab" do
      with_request_url user_path(user) do
        render_inline(described_class.new) do |component|
          component.with_tabs([
                                { name: "Personal Data", path: user_path(user) },
                                { name: "Billing Details", path: user_billing_detail_path(user) },
                                { name: "Company", path: user_occupation_path(user, user.occupation) }
                              ])
        end
      end

      expect(page).to have_link("Personal Data", href: "#", class: "active")

      expect(page).to have_link("Billing Details", href: user_billing_detail_path(user))
      expect(page).not_to have_link("Billing Details", class: "active")

      expect(page).to have_link("Company", href: user_occupation_path(user, user.occupation))
      expect(page).not_to have_link("Company", class: "active")
    end
  end

  context "when rendered in specific url with custom class and current tab" do
    it "renders according to options" do
      with_request_url user_path(user) do
        render_inline(described_class.new) do |component|
          component.with_tabs([
                                { name: "Personal Data", path: "#", current_tab: true },
                                { name: "Billing Details", path: "#", class: %w[nav-link disabled],
                                  current_tab: false },
                                { name: "Company", path: "#", class: %w[nav-link disabled], current_tab: false }
                              ])
        end
      end

      expect(page).to have_link("Personal Data", href: "#", class: "active")
      expect(page).to have_link("Billing Details", href: "#", class: %w[nav-link disabled])
      expect(page).to have_link("Company", href: "#", class: %w[nav-link disabled])
    end
  end
end
