class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :candidate
  belongs_to :election
  
  validates :user, uniqueness: { scope: :election, message: "has already voted in this election" }
  
  before_validation :set_election_id
  
  private
  
  def set_election_id
    self.election_id = candidate.election_id
  end
end
