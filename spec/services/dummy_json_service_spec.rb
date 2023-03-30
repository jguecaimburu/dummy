# frozen_string_literal: true

require "rails_helper"

describe DummyJsonService do
  let(:client_double) { double }
  let(:service) { described_class.new(http_client: client_double) }

  describe "users_data" do
    it "raises RuntimeError on failed request" do
      response_double = double
      allow(response_double).to receive(:success?).and_return(false)
      allow(response_double).to receive(:to_h).and_return({ status: 404 })
      allow(client_double).to receive(:get).and_return(response_double)

      expect { service.users_data }.to raise_error(RuntimeError)
      expect(client_double).to have_received(:get)
        .with(URI("https://dummyjson.com/users"), { skip: 0, limit: 10 }, any_args)
    end

    it "returns parsed data on success" do
      response_double = double
      allow(response_double).to receive(:success?).and_return(true)
      allow(response_double).to receive(:body)
        .and_return({ users: [{ id: 1, firstName: "Juan" }], total: 1, skip: 0, limit: 10 }.to_json)
      allow(client_double).to receive(:get).and_return(response_double)

      data = service.users_data

      expect(data["skip"]).to eq(0)
      expect(data["users"].first["firstName"]).to eq("Juan")
      expect(client_double).to have_received(:get)
        .with(URI("https://dummyjson.com/users"), { skip: 0, limit: 10 }, any_args)
    end

    it "uses given args" do
      response_double = double
      allow(response_double).to receive(:success?).and_return(true)
      allow(response_double).to receive(:body).and_return({ data: "dummy" }.to_json)
      allow(client_double).to receive(:get).and_return(response_double)

      service.users_data(skip: 60, limit: 15)
      expect(client_double).to have_received(:get)
        .with(URI("https://dummyjson.com/users"), { skip: 60, limit: 15 }, any_args)
    end
  end
end
