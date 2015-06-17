# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)
#  session_token   :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#
require 'bcrypt'
#require 'byebug'

class User < ActiveRecord::Base

  has_many :cats, foreign_key: :owner_id, dependent: :destroy
  has_many :rental_requests, class_name:"CatRentalRequest",
            foreign_key: "requester_id", dependent: :destroy

  validates :user_name, :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :password_digest, presence: :true

  after_initialize :set_session_token

  attr_reader :password

  def self.make_session_token
    SecureRandom.urlsafe_base64
  end

  def set_session_token
    self.session_token ||= User.make_session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(self.password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def reset_session_token!
    update(session_token: User.make_session_token)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?
    return user if user.is_password?(password)
    nil
  end

end
