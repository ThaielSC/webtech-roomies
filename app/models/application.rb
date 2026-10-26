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
  validate :listing_must_accept_applications, on: :create
  validate :applicant_cannot_be_the_host, on: :create
  validate :only_one_accepted_application, if: :accepted?

  scope :pending, -> { where(status: :pending) }
  scope :shortlisted, -> { where(status: :shortlisted) }
  scope :accepted, -> { where(status: :accepted) }

  def accept!
    self.class.transaction do
      listing.lock!
      raise ActiveRecord::RecordInvalid, self unless shortlisted? && listing.published?
      raise ActiveRecord::RecordInvalid, self if listing.applications.accepted.where.not(id: id).exists?

      update!(status: :accepted)
      listing.applications.where(status: %w[pending shortlisted]).where.not(id: id).find_each do |other_application|
        other_application.update!(status: :rejected)
      end
      listing.update!(status: :reserved)
    end
    self
  end

  def shortlist!
    raise ActiveRecord::RecordNotSaved unless pending? && listing.published?

    update!(status: :shortlisted)
  end

  def reject!
    raise ActiveRecord::RecordNotSaved unless pending? || shortlisted?

    update!(status: :rejected)
  end

  def withdraw!(actor: user)
    raise ActiveRecord::RecordNotSaved unless actor == user && (pending? || shortlisted?)

    update!(status: :withdrawn)
  end

  private

  def move_in_date_cannot_be_in_the_past
    if move_in_date.present? && move_in_date < Date.current
      errors.add(:move_in_date, "cannot be in the past")
    end
  end

  def listing_must_accept_applications
    return if listing&.published?

    errors.add(:listing, "is not accepting applications")
  end

  def applicant_cannot_be_the_host
    return unless listing && user_id.present? && listing.property.user_id == user_id

    errors.add(:user, "cannot apply to their own listing")
  end

  def only_one_accepted_application
    return unless listing&.applications&.accepted&.where.not(id: id)&.exists?

    errors.add(:listing, "already has an accepted application")
  end
end
