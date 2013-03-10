class User < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :password,
  								:password_confirmation, :birthday, :gender
  has_secure_password

  before_save { |user| user.email = user.email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name, 	presence: true, length: { maximum: 25, minimum: 2 }
  validates :last_name, 	presence: true, length: { maximum: 25, minimum: 2 }
  validates :email, 			presence: true, format: { with: VALID_EMAIL_REGEX },
  												uniqueness: { case_sensitive: false }
  validates :password, 		length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :birthday, 		presence: true
  validates :gender, 			presence: true
  
end