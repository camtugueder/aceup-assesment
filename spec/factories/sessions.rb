FactoryBot.define do
  factory :session do
    coach_hash_id { SecureRandom.hex }
    client_hash_id { SecureRandom.hex }
    start { 1.day.from_now }
    duration { 60 }  # 60 minutes
  end
end