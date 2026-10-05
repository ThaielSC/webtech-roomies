class User < ApplicationRecord
  has_secure_password

  # Asociaciones
  has_many :properties, dependent: :destroy
  has_many :applications, dependent: :destroy
  has_many :saved_listings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :reports, dependent: :destroy

  # Atajo relacional: un anfitrión tiene publicaciones a través de sus propiedades
  has_many :listings, through: :properties

  # Validaciones
  validates :email_address, presence: true,
                            uniqueness: { case_sensitive: false },
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true

  # Método auxiliar para vistas
  def full_name
    "#{first_name} #{last_name}"
  end
end
