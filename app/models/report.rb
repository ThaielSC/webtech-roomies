class Report < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  enum :status, { pending: "pending", reviewed: "reviewed", dismissed: "dismissed", action_taken: "action_taken" }

  validates :reason_category, presence: true
  validates :details, presence: true

  scope :pending, -> { where(status: :pending) }
  scope :actioned, -> { where(status: :action_taken) }
end
