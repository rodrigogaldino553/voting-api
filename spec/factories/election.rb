FactoryBot.define do
  factory :election do
    name { "Election Name" }
    expiration_at { Time.now + 1.week }
    association :user, factory: :user
  end
end
