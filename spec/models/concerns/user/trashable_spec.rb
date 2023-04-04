# frozen_string_literal: true

require "rails_helper"

describe User::Trashable do
  let(:user) { users(:terry_medhurst) }

  describe "self.bulk_trash" do
    before { user.dup.save! }

    context "when all users are trashable" do
      it "trashes all users" do
        user_ids = User.all.pluck(:id)

        expect do
          expect(User.bulk_trash(user_ids)).to be true
        end.to(
          change { User.trashed.count }.by(2)
        )
      end
    end
  end

  describe "trash" do
    context "when trashed for the first time" do
      it "enqueues incineration job" do
        expect do
          expect(user.trash).to be true
        end.to(
          change { UserIncinerationJob.jobs.size }.by(1)
        )
      end
    end

    context "when trashed for the second time" do
      it "enqueues incineration job" do
        user.trashed!

        expect do
          expect(user.trash).to be true
        end.to(
          not_change { UserIncinerationJob.jobs.size }
        )
      end
    end
  end

  describe "incinerating!" do
    context "when user registered" do
      it "raises error" do
        expect { user.incinerating! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when user trashed" do
      it "changes status to incinerating" do
        user.trashed!
        expect { user.incinerating! }.to change { user.status.to_sym }.to(:incinerating)
      end
    end

    context "when user incinerating" do
      it "raises error" do
        user.trashed!
        user.incinerating!
        expect { user.incinerating! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "incinerate!" do
    it "sends email and destroy record" do
      email = user.email
      expect do
        user.incinerate!
      end.to(
        change(User, :count).by(-1)
        .and(change { ActionMailer::Base.deliveries.count }.by(1))
      )
      expect(ActionMailer::Base.deliveries.last.to).to eq([email])
    end
  end
end
