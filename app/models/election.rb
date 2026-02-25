class Election < ApplicationRecord
  has_many :candidates, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :expiration_at, presence: true

  before_validation :set_expiration_at, on: :create
  before_save :name_sanitize

  private

  def set_expiration_at
    self.expiration_at = Time.current + 1.year
  end

  def name_sanitize
    self.name = name.strip.downcase.titleize
  end
end
