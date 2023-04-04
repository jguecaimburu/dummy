# frozen_string_literal: true

require "rails_helper"

describe CachePurgeable do
  let(:user) { users(:terry_medhurst) }

  describe "purge_cache_later" do
    context "when new user created" do
      it "should schedule job to purge cache" do
        expect {
          User.create!(first_name: "Charly", last_name: "Brown")
        }.to(
          change { PurgeCacheJob.jobs.size }.by(1)
        )
      end
    end

    context "when user updated" do
      it "should schedule job to purge cache" do
        expect {
          user.update!(first_name: "Charly", last_name: "Brown")
        }.to(
          not_change { PurgeCacheJob.jobs.size }
        )
      end
    end

    context "when user destroyed" do
      it "should schedule job to purge cache" do
        expect {
          user.destroy!
        }.to(
          change { PurgeCacheJob.jobs.size }.by(1)
        )
      end
    end
  end
end
