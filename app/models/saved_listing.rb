class SavedListing < ApplicationRecord
  # Asociaciones
  belongs_to :user
  belongs_to :listing

  # Validación: un usuario no puede guardar dos veces la misma publicación
  validates :user_id, uniqueness: { scope: :listing_id, message: "has already saved this listing" }
end
