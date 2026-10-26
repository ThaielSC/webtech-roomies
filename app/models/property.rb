class Property < ApplicationRecord
  belongs_to :user
  belongs_to :neighborhood
  has_many :listings, dependent: :destroy
  has_many :property_amenities, dependent: :destroy
  has_many :amenities, through: :property_amenities
  has_many :reviews, dependent: :destroy

  enum :property_type, { apartment: "apartment", house: "house" }

  validates :address, presence: true
  validates :property_type, presence: true
  validates :bedrooms_count, :bathrooms_count,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :in_neighborhood, ->(neighborhood_id) { where(neighborhood_id: neighborhood_id) if neighborhood_id.present? }
end
