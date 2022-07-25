class User < ApplicationRecord
  FIELD_PERMIT = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine.min_cost
             else
              BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  validates :name, presence: true
  validates :email, presence: true,
    length: {
      minimum: Settings.user.email_min,
      maximum: Settings.user.email_max
    },
    format: {with: Settings.user.email_regex},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user.password_min}

  has_secure_password

  def authenticated? remember_token
    return false unless remember_token

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private
  def downcase_email
    email.downcase!
  end
end
