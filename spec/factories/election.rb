FactoryBot.define do
  factory :election do
    name { "Election Name" }
    expiration_at { Time.now + 1.week }
  end
end
