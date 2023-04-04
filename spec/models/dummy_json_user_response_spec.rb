# frozen_string_literal: true

require "rails_helper"

describe DummyJsonUserResponse do
  let(:response) { dummy_json_user_responses(:terry_medhurst_response) }

  describe "#validations" do
    let(:new_response) do
      other_response = response.dup
      other_response.external_reference = 2
      other_response.user_id = nil
      other_response
    end

    context "when all attributes present" do
      it "is valid" do
        expect(new_response).to be_valid
      end
    end

    context "when external reference not present" do
      before { new_response.external_reference = nil }

      it "is invalid" do
        expect(new_response).to be_invalid
      end
    end

    context "when data not present" do
      before { new_response.data = nil }

      it "is invalid" do
        expect(new_response).to be_invalid
      end
    end

    context "when data empty" do
      before { new_response.data = {} }

      it "is invalid" do
        expect(new_response).to be_invalid
      end
    end

    context "when user repeated" do
      before { new_response.user = users(:terry_medhurst) }

      it "is invalid" do
        expect(new_response).to be_invalid
      end
    end
  end

  describe "processing!" do
    context "when response pending" do
      it "changes status to processing" do
        expect { response.processing! }.to change { response.status.to_sym }.to(:processing)
      end
    end

    context "when response processing" do
      it "raises error" do
        response.processing!
        expect { response.processing! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
