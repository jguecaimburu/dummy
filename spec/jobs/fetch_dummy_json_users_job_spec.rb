# frozen_string_literal: true

require "rails_helper"

describe FetchDummyJsonUsersJob do
  describe "perform" do
    let(:pages) { (total / per_page.to_f).ceil }
    let(:user_pages_data) { build_user_pages(total:, per_page:) }

    before do
      User.destroy_all
    end

    context "when all jobs run successfully for 10 pages and 100 users" do
      let(:total) { 100 }
      let(:per_page) { 10 }

      it "saves 100 new users and companies" do
        response_doubles = (0...pages).map do |i|
          response_double = instance_double("response_#{i + 1}")
          allow(response_double).to receive(:success?).and_return(true)
          allow(response_double).to receive(:body).and_return(user_pages_data[i].to_json)
          response_double
        end
        allow(Faraday).to receive(:get).and_return(*response_doubles)

        expect do
          described_class.new.perform
          (pages - 1).times do
            described_class.perform_one
          end
          ParseDummyJsonUsersJob.drain
        end.to(
          change(User, :count).by(100)
          .and(change(Occupation, :count).by(100))
          .and(change(Address, :count).by(100))
          .and(change(Bank, :count).by(100))
          .and(change(DummyJsonUserResponse, :count).by(100))
          .and(change { DummyJsonUserResponse.processed.where.not(user_id: nil).count }.by(100))
          .and(not_change { described_class.jobs.size })
        )
        expect(Faraday).to have_received(:get).exactly(10)
      end
    end

    context "when all jobs run successfully for 10 pages and 95 users" do
      let(:total) { 95 }
      let(:per_page) { 10 }

      it "saves 95 new users and companies" do
        response_doubles = (0...pages).map do |i|
          response_double = instance_double("response_#{i + 1}")
          allow(response_double).to receive(:success?).and_return(true)
          allow(response_double).to receive(:body).and_return(user_pages_data[i].to_json)
          response_double
        end
        allow(Faraday).to receive(:get).and_return(*response_doubles)

        expect do
          described_class.new.perform
          (pages - 1).times do
            described_class.perform_one
          end
          ParseDummyJsonUsersJob.drain
        end.to(
          change(User, :count).by(95)
          .and(change(Occupation, :count).by(95))
          .and(change(Address, :count).by(95))
          .and(change(Bank, :count).by(95))
          .and(change(DummyJsonUserResponse, :count).by(95))
          .and(change { DummyJsonUserResponse.processed.where.not(user_id: nil).count }.by(95))
          .and(not_change { described_class.jobs.size })
        )
        expect(Faraday).to have_received(:get).exactly(10)
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def build_user_pages(total:, per_page:)
    single_user_json = file_fixture("dummy_json/single_user.json").read
    pages = (total / per_page.to_f).ceil

    (0...pages).map do |page|
      skip = page * 10
      users_data = (1..per_page).map do |i|
        user_number = skip + i
        next if user_number > total

        single_user_data = JSON.parse(single_user_json)
        single_user_data["id"] = user_number
        single_user_data["firstName"] = "User N #{user_number}"
        single_user_data["company"]["name"] = "Company for user N#{user_number}"
        single_user_data
      end.compact
      { users: users_data, total: pages * per_page, skip:, limit: per_page }
    end
    # rubocop:enable Metrics/AbcSize
  end
end
