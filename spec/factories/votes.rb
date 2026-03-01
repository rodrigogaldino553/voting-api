FactoryBot.define do
  factory :vote do
    association :user, factory: :user
    association :election, factory: :election
    association :candidate, factory: :candidate
  end
end
