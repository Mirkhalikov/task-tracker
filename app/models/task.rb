class Task < ApplicationRecord
  belongs_to :user
  belongs_to :assigned_user, class_name: 'User', optional: true
  has_and_belongs_to_many :categories
  validates :title, presence: true
end