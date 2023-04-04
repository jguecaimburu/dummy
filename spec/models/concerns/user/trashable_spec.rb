# frozen_string_literal: true

require "rails_helper"

describe User::Trashable do
  let(:user) { users(:terry_medhurst) }

  describe "self.bulk_trash" do
    before { user.dup.save! }

    context "when all users are trashable" do
      it "should trash all users" do
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
      it "should enqueue incineration job" do
        expect do
          expect(user.trash).to be true
        end.to(
          change { UserIncinerationJob.jobs.size }.by(1)
        )
      end
    end

    context "when trashed for the second time" do
      it "should enqueue incineration job" do
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
      it "should raise error" do
        expect { user.incinerating! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when user trashed" do
      it "should change status to incinerating" do
        user.trashed!
        expect { user.incinerating! }.to change { user.status.to_sym }.to(:incinerating)
      end
    end

    context "when user incinerating" do
      it "should raise error" do
        user.trashed!
        user.incinerating!
        expect { user.incinerating! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "incinerate!" do
    it "should send email and destroy record" do
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