# frozen_string_literal: true

require "rails_helper"

describe "admin visits user index" do
  context "when there are users" do
    before do
      User.destroy_all
      create_user_with_associatied_objects!(first_name: "Arthur", last_name: "Dent", age: 30, gender: :male)
      create_user_with_associatied_objects!(first_name: "Trillian", last_name: "McMillan", age: 35, gender: :female)
      create_user_with_associatied_objects!(first_name: "Ford", last_name: "Prefect", age: 40, gender: :male)
      create_user_with_associatied_objects!(first_name: "Marvin", last_name: "Paranoid", age: 45, gender: :female)
      create_user_with_associatied_objects!(first_name: "Zaphod", last_name: "Beeblebrox", age: 50, gender: :male)
      create_user_with_associatied_objects!(first_name: "Alice", last_name: "Beeblebrox", age: 55, gender: :female)
      create_user_with_associatied_objects!(first_name: "Elvis", last_name: "Presley", age: 60, gender: :male)
      create_user_with_associatied_objects!(first_name: "Enid", last_name: "Kapelsen", age: 65, gender: :female)
      create_user_with_associatied_objects!(first_name: "Humma", last_name: "Kavula", age: 70, gender: :male)
      create_user_with_associatied_objects!(first_name: "Vogon", last_name: "Captain", age: 75, gender: :female)
      create_user_with_associatied_objects!(first_name: "Slartibast", last_name: "Fast", age: 80, gender: :male)
      expect(User.count).to eq(11)
      expect(Address.count).to eq(11)
      expect(Bank.count).to eq(11)
      expect(Occupation.count).to eq(11)
    end
    
    it "should be able to see, filter, reset and destroy users" do
      visit users_path

      expect(page).to have_link("New user")
      
      expect(page).to have_table
      within("tbody") do
        expect(page).to have_selector("tr", count: 10)
      end
      expect(page).to have_link("2")

      choose "female"
      click_button "Search"
      expect(page).to have_table
      within("tbody") do
        expect(page).to have_selector("tr", count: 5)
      end
      expect(page).to have_no_link("2")


      fill_in "To age", with: 35
      click_button "Search"
      expect(page).to have_table
      within("tbody") do
        expect(page).to have_selector("tr", count: 1)
      end
      expect(page).to have_no_link("2")

      fill_in "To age", with: 35
      click_button "Search"
      expect(page).to have_table
      within("tbody") do
        expect(page).to have_selector("tr", count: 1)
      end
      expect(page).to have_no_link("2")

      click_link "Reset"
      expect(page).to have_table
      within("tbody") do
        expect(page).to have_selector("tr", count: 10)
      end
      expect(page).to have_link("2")

      fill_in "Search term", with: "A"
      click_button "Search"
      expect(page).to have_table
      within("tbody") do
        expect(page).to have_selector("tr", count: 2)
        expect(page).to have_text("Arthur")
        expect(page).to have_text("Alice")
      end
      expect(page).to have_no_link("2")

      fill_in "Search term", with: "Any random search"
      click_button "Search"
      expect(page).to have_table
      within("tbody") do
        expect(page).to have_no_selector("tr")
      end
      expect(page).to have_text("No results found.")
      
      click_link "Click to reset the filters."
      expect(page).to have_table
      within("tbody") do
        expect(page).to have_selector("tr", count: 10)
      end
      expect(page).to have_link("2")

      user = User.find_by(first_name: "Arthur")

      within("#row_user_#{user.id}") do
        expect(page).to have_link("Details")
        expect(page).to have_button("Delete")
      end

      expect do
        within("#row_user_#{user.id}") do
          click_button "Delete"
        end
        expect(page).to have_table
        expect(page).to have_no_text("Arthur")
      end.to(
        change { User.trashed.count }.by(1)
      )
    end
  end

  def create_user_with_associatied_objects!(**user_attributes)
    address_attributes = { address: "155 Country Lane", city: "Cottington", state: "Cottingshire" }
    occupation_attributes = { company_name: "Sirius Cybernetics Corporation", title: "Robot designer" }
    bank_attributes = { iban: "NO17 0695 2754 967" }
    full_attributes = user_attributes.merge(
      address_attributes: address_attributes,
      bank_attributes: bank_attributes,
      occupation_attributes: occupation_attributes
    )
    user = User.create!(full_attributes)
  end
end