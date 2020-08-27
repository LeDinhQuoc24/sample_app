class User < ApplicationRecord
  VALID_EMAIL_REGEX =
    /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  before_save{self.email = email.downcase}

  validates :name, presence: true,
    length: {maximum: Settings.model.user.name.maximum}

  validates :email, presence: true,
    length: {maximum: Settings.model.user.email.maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true

  validates :password, presence: true,
    length: {minimum: Settings.model.user.password.minimum}

  has_secure_password
end
