FactoryBot.define do
  factory :reservation do
    reservation_date { "2025-08-05" }
    reservation_time { "2025-08-05 06:25:29" }
    number_of_guests { 1 }
    status { 1 }
    user { nil }
    restaurant { nil }
    table { nil }
  end
end
