FactoryBot.define do
  factory :candidate do
    name { "Candidate Name" }
    association :election, factory: :election
  end
end
