class Review < ApplicationRecord
  belongs_to :visit
  belongs_to :property
  belongs_to :user

  validates :comment, presence: true
  validates :rating, presence: true, numericality: { only_integer: true, in: 1..5 }

  validates :visit_id, uniqueness: { message: "already has an associated review" }

  validate :visit_must_be_completed

  scope :recent, -> { order(created_at: :desc) }
  scope :positive, -> { where("rating >= 4") }

  private

  def visit_must_be_completed
    if visit.present? && !visit.completed?
      errors.add(:visit, "must be completed before submitting a review")
    end
  end
end
