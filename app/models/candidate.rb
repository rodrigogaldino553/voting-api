class Candidate < ApplicationRecord
  belongs_to :election

  validates :name, presence: true
  validates :election_id, presence: true

  before_save :name_sanitize

  private

  def name_sanitize
    self.name = name.strip.downcase.titleize
  end
end
