class Visit < ApplicationRecord
  belongs_to :application
  has_one :review, dependent: :destroy
  has_one :listing, through: :application
  has_one :user, through: :application

  enum :status, { proposed: "proposed", confirmed: "confirmed", completed: "completed", cancelled: "cancelled" }

  validates :date_time, presence: true

  validate :visit_date_must_be_after_application_creation
  validate :application_must_be_shortlisted, on: :create
  validate :visit_must_not_be_in_the_past

  scope :completed, -> { where(status: :completed) }
  scope :upcoming, -> { where("date_time >= ?", Time.current) }

  private

  def visit_date_must_be_after_application_creation
    if date_time.present? && application.present? && application.created_at.present? && date_time < application.created_at
      errors.add(:date_time, "must be scheduled after application was created")
    end
  end

  def application_must_be_shortlisted
    return if application&.shortlisted?

    errors.add(:application, "must be shortlisted before proposing a visit")
  end

  def visit_must_not_be_in_the_past
    return if date_time.blank? || date_time >= Time.current

    errors.add(:date_time, "cannot be in the past")
  end
end
