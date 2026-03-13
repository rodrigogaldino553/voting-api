require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(email: "test@example.com", password: "password123")
      expect(user).to be_valid
    end

    it "is invalid without an email" do
      user = User.new(email: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with an incorrect email format" do
      user = User.new(email: "invalid-email")
      expect(user).not_to be_valid
    end

    it "is invalid without a password" do
      user = User.new(password: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with a password shorter than 6 characters" do
      user = User.new(password: "12345")
      expect(user).not_to be_valid
    end
  end

  describe "associations" do
    it "has many elections" do
      association = described_class.reflect_on_association(:elections)
      expect(association.macro).to eq(:has_many)
    end

    it "has many votes" do
      association = described_class.reflect_on_association(:votes)
      expect(association.macro).to eq(:has_many)
    end

    it "destroys associated elections when user is destroyed" do
      user = create(:user)
      create(:election, user: user)
      expect { user.destroy }.to change(Election, :count).by(-1)
    end

    it "destroys associated votes when user is destroyed" do
      user = create(:user)
      election = create(:election)
      candidate = create(:candidate, election: election)
      create(:vote, user: user, candidate: candidate, election: election)
      expect { user.destroy }.to change(Vote, :count).by(-1)
    end
  end

  describe "JWT revocation strategy" do
    it "includes JTIMatcher" do
      expect(User.included_modules).to include(Devise::JWT::RevocationStrategies::JTIMatcher)
    end

    it "has a JTI" do
      user = create(:user)
      expect(user.jti).not_to be_nil
    end
  end
end
