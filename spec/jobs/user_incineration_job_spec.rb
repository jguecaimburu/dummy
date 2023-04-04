# frozen_string_literal: true

require "rails_helper"

describe UserIncinerationJob do
  let(:user) { users(:terry_medhurst) }

  context "when user registered" do
    it "should return without changing user" do
      expect do
        described_class.new.perform(user.id)
      end.to(
        not_change(User, :count)
        .and(not_change(user, :status))
      )
    end
  end

  context "when user trashed" do
    it "should incinerate user" do
      user.trashed!
      email = user.email
      expect do
        described_class.new.perform(user.id)
      end.to(
        change(User, :count).by(-1)
        .and(change { ActionMailer::Base.deliveries.count }.by(1))
      )
      expect(ActionMailer::Base.deliveries.last.to).to eq([email])
    end
  end

  context "when user incinerating" do
    # NOTE: Error will be raised on a race condition, for example
    #       if two workers try to execute the job at the same time
    it "should return without changing user" do
      user.trashed!
      user.incinerating!

      expect do
        described_class.new.perform(user.id)
      end.to(
        not_change(User, :count)
        .and(not_change(user, :status))
      )
    end
  end
end
