require "rails_helper"

RSpec.describe Election, type: :model do
  describe "validations" do
    let(:election) { Election.new(name: "New Election", expiration_at: Time.current + 1.week) }
    it "is valid with valid attributes" do
      expect(election).to be_valid
    end

    it "is invalid without a name" do
      election.name = nil
      expect(election).not_to be_valid
    end

    it "is invalid with a duplicate name" do
      create(:election, name: "New Election")
      expect(election).not_to be_valid
    end
  end

  describe "associations" do
    it "has many candidates" do
      association = described_class.reflect_on_association(:candidates)
      expect(association.macro).to eq :has_many
    end

    it "destroys dependent candidates" do
      election = create(:election)
      election.candidates.create!(name: "Candidate 1")
      expect { election.destroy }.to change(Candidate, :count).by(-1)
    end
  end

  describe "callbacks" do
    it "sets expiration_at on create" do
      election = create(:election, name: "Another Election")
      expect(election.expiration_at).not_to be_nil
      expect(election.expiration_at).to be_within(1.day).of(Time.current + 1.year)
    end

    it "sanitizes the name before saving" do
      sanitized_election = create(:election, name: "  test election  ")
      expect(sanitized_election.name).to eq("Test Election")
    end
  end
end
