class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :candidate
  belongs_to :election

  validates :user, uniqueness: {scope: :election, message: "has already voted in this election"}
end
