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
  validate :accepted_application_must_use_accept_action, on: :create, if: :accepted?
  validate :only_one_accepted_application, if: :accepted?

  before_update :status_changes_must_use_transition_methods, if: :will_save_change_to_status?

  scope :pending, -> { where(status: :pending) }
  scope :shortlisted, -> { where(status: :shortlisted) }
  scope :accepted, -> { where(status: :accepted) }

  def accept!
    self.class.transaction do
      listing.lock!
      unless shortlisted? && listing.published?
        errors.add(:status, "can only be accepted while shortlisted on a published listing")
        raise ActiveRecord::RecordInvalid.new(self)
      end
      if listing.applications.accepted.where.not(id: id).exists?
        errors.add(:listing, "already has an accepted application")
        raise ActiveRecord::RecordInvalid.new(self)
      end

      transition_status!(:accepted)
      listing.applications.where(status: %w[pending shortlisted]).where.not(id: id).find_each do |other_application|
        other_application.reject!
      end
      listing.reserve!
    end
    self
  end

  def shortlist!
    raise ActiveRecord::RecordNotSaved, "Only pending applications on published listings can be shortlisted." unless pending? && listing.published?

    transition_status!(:shortlisted)
  end

  def reject!
    raise ActiveRecord::RecordNotSaved, "Only pending or shortlisted applications can be rejected." unless pending? || shortlisted?

    transition_status!(:rejected)
  end

  def withdraw!(actor: user)
    unless actor == user && (pending? || shortlisted?)
      raise ActiveRecord::RecordNotSaved, "Only the applicant can withdraw a pending or shortlisted application."
    end

    transition_status!(:withdrawn)
  end

  private

  def transition_status!(new_status)
    @allow_status_transition = true
    update!(status: new_status)
  ensure
    @allow_status_transition = false
  end

  def status_changes_must_use_transition_methods
    return if @allow_status_transition

    errors.add(:status, "must be changed through an application action")
    throw :abort
  end

  def accepted_application_must_use_accept_action
    return if @allow_status_transition

    errors.add(:status, "must be accepted through the application workflow")
  end

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
