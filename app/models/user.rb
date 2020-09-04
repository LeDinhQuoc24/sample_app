class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  scope :activated, ->{where(activated: FILL_IN)}
  before_save   :downcase_email
  before_create :create_activation_digest
  VALID_EMAIL_REGEX =
    /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  validates :name, presence: true,
    length: {maximum: Settings.model.user.name.maximum}

  validates :email, presence: true,
    length: {maximum: Settings.model.user.email.maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true

  validates :password, presence: true,
    length: {minimum: Settings.model.user.password.minimum},
    allow_nil: true

  has_secure_password

  # Returns the hash digest of the given string.
  def self.digest string
    if cost = ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update remember_digest: nil
  end

  # Activates an account.
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
