class Report < ApplicationRecord
  # Asociaciones
  belongs_to :user
  belongs_to :listing

  # Enum del ciclo de moderación
  enum :status, { pending: "pending", reviewed: "reviewed", dismissed: "dismissed", action_taken: "action_taken" }

  # Validaciones
  validates :reason_category, presence: true
  validates :details, presence: true

  # Scopes
  scope :pending, -> { where(status: :pending) }
  scope :actioned, -> { where(status: :action_taken) }
end
