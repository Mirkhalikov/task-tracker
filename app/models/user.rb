class User < ApplicationRecord
  has_one_attached :avatar
  has_secure_password
  has_many :tasks
  validates :username, presence: true, uniqueness: true
end
