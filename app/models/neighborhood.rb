class Neighborhood < ApplicationRecord
  has_many :properties, dependent: :restrict_with_error
  has_many :listings, through: :properties

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
