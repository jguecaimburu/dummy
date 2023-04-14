# frozen_string_literal: true

require "rails_helper"

describe User do
  let(:user) { users(:terry_medhurst) }

  describe "#validations" do
    let(:new_user) { user.dup }

    context "when all attributes present" do
      it "is valid" do
        expect(new_user).to be_valid
      end
    end

    context "when only first name and last name present" do
      it "is valid" do
        expect(described_class.new(first_name: "Charly", last_name: "Brown")).to be_valid
      end
    end

    context "when first name not present" do
      before { new_user.first_name = nil }

      it "is invalid" do
        expect(new_user).to be_invalid
      end
    end

    context "when last name not present" do
      before { new_user.last_name = nil }

      it "is invalid" do
        expect(new_user).to be_invalid
      end
    end

    context "when age is negative" do
      before { new_user.age = -10 }

      it "is invalid" do
        expect(new_user).to be_invalid
      end
    end

    context "when age is bigger than max" do
      before { new_user.age = 300 }

      it "is invalid" do
        expect(new_user).to be_invalid
      end
    end

    context "when age is zero" do
      before { new_user.age = 0 }

      it "is invalid" do
        expect(new_user).to be_invalid
      end
    end

    context "when age is float" do
      before { new_user.age = 1.5 }

      it "is invalid" do
        expect(new_user).to be_invalid
      end
    end
  end

  describe "name" do
    it "returns first and last name" do
      expect(user.name).to eq("Terry Medhurst")
    end
  end

  describe "self.by_age" do
    context "when user age in range and both range ends present" do
      it "returns a relation including record" do
        expect(described_class.by_age(from: 30, to: 60).pluck(:id)).to include(user.id)
      end
    end

    context "when user age in range and from not given" do
      it "returns a relation including record" do
        expect(described_class.by_age(to: 60).pluck(:id)).to include(user.id)
      end
    end

    context "when user age in range and to not given" do
      it "returns a relation including record" do
        expect(described_class.by_age(from: 30).pluck(:id)).to include(user.id)
      end
    end

    context "when user age in range and from blank" do
      it "returns a relation including record" do
        expect(described_class.by_age(from: "", to: 60).pluck(:id)).to include(user.id)
      end
    end

    context "when user age in range and to blank" do
      it "returns a relation including record" do
        expect(described_class.by_age(from: 30, to: "").pluck(:id)).to include(user.id)
      end
    end

    context "when user age not in range" do
      it "returns a relation not including record" do
        expect(described_class.by_age(from: 30, to: 45).pluck(:id)).not_to include(user.id)
      end
    end

    context "when user age equals lower limit" do
      it "returns a relation including record" do
        expect(described_class.by_age(from: 50, to: 60).pluck(:id)).to include(user.id)
      end
    end

    context "when user age equals upper limit" do
      it "returns a relation including record" do
        expect(described_class.by_age(from: 40, to: 50).pluck(:id)).to include(user.id)
      end
    end
  end

  describe "self.by_full_name_and_email" do
    context "when search term is the start of the first name" do
      it "returns a relation including record" do
        expect(described_class.by_full_name_and_email("Ter").pluck(:id)).to include(user.id)
      end
    end

    context "when search term is the start of the last name" do
      it "returns a relation including record" do
        expect(described_class.by_full_name_and_email("Med").pluck(:id)).to include(user.id)
      end
    end

    context "when search term is the start of the maiden name" do
      it "returns a relation including record" do
        expect(described_class.by_full_name_and_email("Smi").pluck(:id)).to include(user.id)
      end
    end

    context "when search term is the name" do
      it "returns a relation including record" do
        expect(described_class.by_full_name_and_email("Terry Medhurst").pluck(:id)).to include(user.id)
      end
    end

    context "when search term is the mid part of the name" do
      it "returns a relation not including record" do
        expect(described_class.by_full_name_and_email("rry").pluck(:id)).not_to include(user.id)
      end
    end

    context "when search term is the start of the email" do
      it "returns a relation including record" do
        expect(described_class.by_full_name_and_email("atu").pluck(:id)).to include(user.id)
      end
    end

    context "when search term is the email" do
      it "returns a relation including record" do
        expect(described_class.by_full_name_and_email("atuny0@sohu.com").pluck(:id)).to include(user.id)
      end
    end

    context "when search term is the start of the email domain" do
      it "returns a relation not including record" do
        expect(described_class.by_full_name_and_email("sohu").pluck(:id)).not_to include(user.id)
      end
    end
  end
end
