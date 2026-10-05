class Listing < ApplicationRecord
  belongs_to :property
  has_one :neighborhood, through: :property
  has_one :host, through: :property, source: :user
  has_many :applications, dependent: :destroy
  has_many :saved_listings, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :reviews, through: :property

  enum :status, { draft: "draft", published: "published", reserved: "reserved", rented: "rented", withdrawn: "withdrawn" }

  validates :title, presence: true
  validates :monthly_rent, presence: true, numericality: { greater_than: 0 }
  validates :deposit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :available_date, presence: true
  validates :minimum_stay_months, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :available_date_cannot_be_in_the_past, on: :create

  scope :published, -> { where(status: :published) }
  scope :available_from, ->(date) { where("available_date >= ?", date) if date.present? }
  scope :under_rent, ->(max_rent) { where("monthly_rent <= ?", max_rent) if max_rent.present? }
  scope :in_neighborhood, ->(neighborhood_id) { joins(:property).where(properties: { neighborhood_id: neighborhood_id }) if neighborhood_id.present? }

  private

  def available_date_cannot_be_in_the_past
    if available_date.present? && available_date < Date.current
      errors.add(:available_date, "cannot be in the past")
    end
  end
end
