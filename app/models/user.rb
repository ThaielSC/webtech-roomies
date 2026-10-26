class User < ApplicationRecord
  has_secure_password

  has_many :properties, dependent: :destroy
  has_many :applications, dependent: :destroy
  has_many :saved_listings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :reports, dependent: :destroy

  has_many :listings, through: :properties

  validates :email_address, presence: true,
                            uniqueness: { case_sensitive: false },
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
