FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "testuser#{n}" }
    password { "password" }
    password_confirmation { "password" }
  end
end