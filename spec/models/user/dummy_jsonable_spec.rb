# frozen_string_literal: true

require "rails_helper"

describe User::DummyJsonable do
  let(:input_data) { JSON.parse(file_fixture("dummy_json/single_user.json").read) }

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe "process_dummy_json_data" do
    let(:output_user_data) do
      {
        first_name: "Terry",
        last_name: "Medhurst",
        maiden_name: "Smitham",
        age: 50,
        gender: "male",
        email: "atuny0@sohu.com",
        phone: "+63 791 675 8914",
        username: "atuny0",
        password: "9uQFF1Lh",
        birth_date: "2000-12-25",
        image: "https://robohash.org/hicveldicta.png",
        blood_group: "A−",
        height: 189,
        weight: 75.4,
        eye_color: "Green",
        hair_color: "Black",
        hair_type: "Strands",
        domain: "slashdot.org",
        ip: "117.29.86.254",
        mac_address: "13:69:BA:56:A3:74",
        university: "Capitol University",
        ein: "20-9487066",
        ssn: "661-64-2976",
        user_agent:
          "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/12.0.702.0 Safari/534.24"
      }
    end
    let(:output_occupation_data) do
      {
        company_name: "Blanda-O'Keefe",
        department: "Marketing",
        title: "Help Desk Operator",
        address: "629 Debbie Drive",
        city: "Nashville",
        postal_code: "37076",
        state: "TN",
        latitude: 36.208114,
        longitude: -86.58621199999999
      }
    end
    let(:output_bank_data) do
      {
        card_expire: "06/22",
        card_number: "50380955204220685",
        card_type: "maestro",
        currency: "Peso",
        iban: "NO17 0695 2754 967"
      }
    end
    let(:output_address_data) do
      {
        address: "1745 T Street Southeast",
        city: "Washington",
        postal_code: "20020",
        state: "DC",
        latitude: 38.867033,
        longitude: -76.979235
      }
    end

    it "returns the right hash" do
      processed_data = User.process_dummy_json_data(input_data)

      expect(processed_data.except(:address_attributes, :bank_attributes, :occupation_attributes)).to eq(output_user_data)
      expect(processed_data[:address_attributes]).to eq(output_address_data)
      expect(processed_data[:bank_attributes]).to eq(output_bank_data)
      expect(processed_data[:occupation_attributes]).to eq(output_occupation_data)
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers

  describe "create_from_dummy_json_response!" do
    let(:dummy_json_user_response) do
      DummyJsonUserResponse.create!(data: input_data, external_reference: input_data["id"])
    end

    context "when new user and new company" do
      it "creates all new records with json data" do
        expect do
          User.create_from_dummy_json_response!(dummy_json_user_response)
        end.to(
          change(User, :count).by(1)
          .and(change(Occupation, :count).by(1))
          .and(change(Address, :count).by(1))
          .and(change(Bank, :count).by(1))
          .and(change { DummyJsonUserResponse.where.not(user_id: nil).count }.by(1))
        )
      end
    end

    context "when existing user" do
      before { User.create_from_dummy_json_response!(dummy_json_user_response) }

      it "does not create any record" do
        expect do
          User.create_from_dummy_json_response!(dummy_json_user_response)
        end.to(
          not_change { User.count }
          .and(not_change { Occupation.count })
          .and(not_change { Address.count })
          .and(not_change { Bank.count })
        )
      end
    end
  end
end
