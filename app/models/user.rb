class User < ActiveRecord::Base
  has_many :recipes
  has_secure_password
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password_digest, presence: true

  def self.logged_in?(session)
    !!session[:user_id]
  end

  def self.current_user(session)
    User.find_by(id: session[:user_id])
  end
end