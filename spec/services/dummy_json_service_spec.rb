# frozen_string_literal: true

require "rails_helper"

describe DummyJsonService do
  let(:client_double) { double }
  let(:service) { described_class.new(http_client: client_double) }

  describe "users_data" do
    it "returns nil on failed request" do
      response_double = double
      allow(response_double).to receive(:success?).and_return(false)
      allow(client_double).to receive(:get).and_return(response_double)

      expect(service.users_data).to be_nil
      expect(client_double).to have_received(:get)
        .with(URI("https://dummyjson.com/users"), { skip: 0, limit: 10 }, any_args)
    end

    it "returns parsed data on success" do
      response_double = double
      allow(response_double).to receive(:success?).and_return(true)
      allow(response_double).to receive(:body).and_return([{ id: 1, first_name: "Juan" }].to_json)
      allow(client_double).to receive(:get).and_return(response_double)

      expect(service.users_data.first["first_name"]).to eq("Juan")
      expect(client_double).to have_received(:get)
        .with(URI("https://dummyjson.com/users"), { skip: 0, limit: 10 }, any_args)
    end

    it "uses given args" do
      response_double = double
      allow(response_double).to receive(:success?).and_return(false)
      allow(client_double).to receive(:get).and_return(response_double)

      service.users_data(skip: 60, limit: 15)
      expect(client_double).to have_received(:get)
        .with(URI("https://dummyjson.com/users"), { skip: 60, limit: 15 }, any_args)
    end
  end
end
