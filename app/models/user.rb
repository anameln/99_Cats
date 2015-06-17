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

class User < ActiveRecord::Base

  validates :user_name, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true

  after_initialize :set_session_token

  def self.make_session_token
    SecureRandom.urlsafe_base64
  end

  def set_session_token
    self.session_token ||= User.make_session_token
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    user.is_password?(password)
  end

end
