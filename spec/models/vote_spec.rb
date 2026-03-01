require "rails_helper"

RSpec.describe Vote, type: :model do
  describe "validations" do
    let(:user) { create(:user) }
    let(:election) { create(:election) }
    let(:candidate1) { create(:candidate, name: "Candidate 1", election: election) }
    let(:candidate2) { create(:candidate, name: "Candidate 2", election: election) }
    it "user can vote in just one candidate per election" do
      vote = create(:vote, user: user, candidate: candidate1, election: election)
      expect(vote).to be_valid

      vote.save!

      expect { create(:vote, user: user, candidate: candidate2, election: election) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
