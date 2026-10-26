class Listing < ApplicationRecord
  belongs_to :property
  has_one :neighborhood, through: :property
  has_one :host, through: :property, source: :user
  has_many :applications, dependent: :destroy
  has_many :saved_listings, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :reviews, through: :property

  # Active Storage: múltiples fotografías
  has_many_attached :photos

  # Action Text: descripción y reglas de convivencia
  has_rich_text :description
  has_rich_text :house_rules

  # Enum del ciclo de vida
  enum :status, {
    draft: "draft",
    published: "published",
    reserved: "reserved",
    rented: "rented",
    withdrawn: "withdrawn"
  }
  validates :title, presence: true
  validates :monthly_rent, presence: true,
            numericality: { greater_than: 0 }
  validates :deposit, presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :available_date, presence: true
  validates :minimum_stay_months, presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  validate :available_date_cannot_be_in_the_past, on: :create

  # Validación de fotografías
  validate :validate_photos

  # Scopes requeridos por la entrega
  scope :published, -> { where(status: :published) }
  scope :visible_to, ->(user) { joins(:property).where(status: :published).or(joins(:property).where(status: :draft, properties: { user_id: user&.id })) }

  def publish!
    transition_to!(:published, from: :draft)
  end

  def withdraw!
    transition_to!(:withdrawn, from: %i[draft published reserved])
  end

  def mark_rented!
    transition_to!(:rented, from: :reserved)
  end

  scope :available_from, ->(date) {
    where("available_date >= ?", date) if date.present?
  }

  scope :under_rent, ->(max_rent) {
    where("monthly_rent <= ?", max_rent) if max_rent.present?
  }

  scope :in_neighborhood, ->(neighborhood_id) {
    joins(:property).where(properties: { neighborhood_id: neighborhood_id }) if neighborhood_id.present?
  }

  private

  def transition_to!(target, from:)
    raise ActiveRecord::RecordNotSaved, "Invalid listing state transition" unless from.any? { |state| public_send("#{state}?") }

    update!(status: target)
  end

  def available_date_cannot_be_in_the_past
    if available_date.present? && available_date < Date.current
      errors.add(:available_date, "cannot be in the past")
    end
  end

  def validate_photos
    photos.each do |photo|
      next unless photo.blob

      unless photo.blob.content_type.in?(%w[image/jpeg image/png image/webp])
        errors.add(:photos, "must be JPEG, PNG, or WebP images")
      end

      if photo.blob.byte_size > 5.megabytes
        errors.add(:photos, "must be smaller than 5 MB each")
      end
    end
  end
end