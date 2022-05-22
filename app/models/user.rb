class User < ApplicationRecord
  has_secure_password
  has_many :tasks

  EMAIL_FORMAT= /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :password, presence: true, length: { minimum: 6 }
  validates :email, presence: true, length: { maximum: 120 }, format: { with: EMAIL_FORMAT }, uniqueness: { case_sensitive: false }
  before_save { self.email = email.downcase }
end
