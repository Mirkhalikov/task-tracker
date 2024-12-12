FactoryBot.define do
  factory :task do
    title { "My Task" }
    description { "Task Description" }
    user
  end
end
