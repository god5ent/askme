require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  BG_COLOR_REGEX= /\A#\h{3}{1,2}\z/
  USERNAME_REGEX = /\A\w+\z/

  attr_accessor :password
  has_many :questions, dependent: :destroy

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
  validates :email, email: { mode: :strict }
  validates :username, length: { maximum: 40 }
  validates :username, format: { with: USERNAME_REGEX }
  validates_presence_of :password, on: :create
  validates_confirmation_of :password
  validates :background_color, format: {with: BG_COLOR_REGEX}

  before_validation :convert_to_downcase
  before_save :encrypt_password

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email&.downcase)
    return user if user.present? && user.password_hash == User.hash_to_string(
                                                          OpenSSL::PKCS5.pbkdf2_hmac(
                                                          password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST))
  end

  private

  def encrypt_password
    if password.present?
      self.password_salt = User.hash_to_string(
                           OpenSSL::Random.random_bytes(16))
      self.password_hash = User.hash_to_string(
                           OpenSSL::PKCS5.pbkdf2_hmac(
                           self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST))
    end
  end

  def convert_to_downcase
    username&.downcase!
    email&.downcase!
  end
end
