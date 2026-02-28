require "rails_helper"

RSpec.describe Candidate, type: :model do
  let(:election) { Election.create!(name: "Test Election") }
  let(:candidate) { Candidate.new(name: "Candidate Name", election: election) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(candidate).to be_valid
    end

    it "is invalid without a name" do
      candidate.name = nil
      expect(candidate).not_to be_valid
    end

    it "is invalid without an election" do
      candidate.election = nil
      expect(candidate).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to an election" do
      association = described_class.reflect_on_association(:election)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe "callbacks" do
    it "sanitizes the name before saving" do
      candidate = Candidate.create!(name: "  candidate name  ", election: election)
      expect(candidate.name).to eq("Candidate Name")
    end
  end
end
