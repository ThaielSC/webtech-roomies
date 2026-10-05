class Application < ApplicationRecord
  belongs_to :user
  belongs_to :listing
  has_many :visits, dependent: :destroy

  enum :status, { pending: "pending", shortlisted: "shortlisted", accepted: "accepted", rejected: "rejected", withdrawn: "withdrawn" }

  validates :message, presence: true
  validates :move_in_date, presence: true
  validates :intended_stay_months, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validates :user_id, uniqueness: { scope: :listing_id, message: "has already applied to this listing" }

  validate :move_in_date_cannot_be_in_the_past, on: :create

  scope :pending, -> { where(status: :pending) }
  scope :shortlisted, -> { where(status: :shortlisted) }
  scope :accepted, -> { where(status: :accepted) }

  private

  def move_in_date_cannot_be_in_the_past
    if move_in_date.present? && move_in_date < Date.current
      errors.add(:move_in_date, "cannot be in the past")
    end
  end
end
