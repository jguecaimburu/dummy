# frozen_string_literal: true

require "rails_helper"

describe "admin visits user index" do
  context "when there are users" do
    before do
      User.destroy_all
    end

    it "is able to see, filter, reset and destroy users" do
      visit users_path

      expect(page).to have_table
      within("tbody") do
        expect(page).not_to have_selector("tr")
      end
      expect(page).to have_text("No results found.")
      expect(page).to have_text("If you just fetched users, try refreshing in a moment.")

      click_link "New user"

      fill_in "First name", with: "Arthur"
      fill_in "Last name", with: "Dent"
      fill_in "Age", with: 30
      select "O+", from: "Blood group"

      expect do
        click_button "Create User"
        expect(page).to have_text("Arthur")
      end.to(
        change(User, :count).by(1)
        .and(change { PurgeCacheJob.jobs.size }.by(1))
      )

      user = User.last
      expect(user.name).to eq("Arthur Dent")

      click_link "Edit"
      fill_in "Last name", with: ""
      expect do
        click_button "Update User"
        expect(page).to have_text("1 error prohibited this user from being saved")
      end.to(
        not_change { user.reload.last_name }
      )

      expect do
        click_link "Cancel"
        expect(page).to have_link("Edit")
      end.to(
        not_change { user.reload.last_name }
      )

      click_link "Edit"
      fill_in "Last name", with: "Arturo"
      expect do
        click_button "Update User"
        expect(page).not_to have_text("error")
      end.to(
        change { user.reload.last_name }.to("Arturo")
        .and(not_change { PurgeCacheJob.jobs.size })
      )

      click_link "Billing Details"

      expect(page).not_to have_link("Cancel")
      fill_in "Iban", with: "NO17 0695 2754 967"
      expect do
        click_button "Create Bank"
        expect(page).to have_text("NO17 0695 2754 967")
      end.to(
        change(Bank, :count).by(1)
      )
      expect(Bank.last.user).to eq(user)

      fill_in "Address", with: "155 Country Lane"
      fill_in "City", with: "Cottington"
      fill_in "State", with: "Cottingshire"
      expect do
        click_button "Create Address"
        expect(page).to have_text("Cottington")
      end.to(
        change(Address, :count).by(1)
      )
      expect(Address.last.user).to eq(user)

      click_link "Company"
      expect(page).not_to have_link("Cancel")
      fill_in "Company name", with: "Sirius Cybernetics Corporation"
      expect do
        click_button "Create Company"
        expect(page).to have_text("Sirius Cybernetics Corporation")
      end.to(
        change(Occupation, :count).by(1)
      )
      expect(Occupation.last.user).to eq(user)
    end
  end
end
