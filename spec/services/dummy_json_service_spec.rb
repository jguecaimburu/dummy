# frozen_string_literal: true

require "rails_helper"

describe DummyJsonService do
  let(:client_double) { double }
  let(:service) { DummyJsonService.new(http_client: client_double) }

  describe :users_data do
    it "should return nil on failed request" do
      response_double = double
      allow(response_double).to receive(:success?).and_return(false)
      allow(client_double).to receive(:get).and_return(response_double)

      expect(client_double).to receive(:get).with(URI("https://dummyjson.com/users"), { skip: 0, limit: 10 }, any_args)
      expect(service.users_data).to be_nil
    end

    it "should return parsed data on success" do
      response_double = double
      allow(response_double).to receive(:success?).and_return(true)
      allow(response_double).to receive(:body).and_return([{ id: 1, first_name: "Juan" }].to_json)

      expect(client_double).to receive(:get)
                                 .with(URI("https://dummyjson.com/users"), { skip: 0, limit: 10 }, any_args)
                                 .and_return(response_double)

      expect(service.users_data.first["first_name"]).to eq("Juan")
    end

    it "should use given args" do
      response_double = double
      allow(response_double).to receive(:success?).and_return(false)
      
      expect(client_double).to receive(:get)
                                 .with(URI("https://dummyjson.com/users"), { skip: 60, limit: 15 }, any_args)
                                 .and_return(response_double)
                                 
      service.users_data(skip: 60, limit: 15)
    end
  end
end