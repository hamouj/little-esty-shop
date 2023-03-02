FactoryBot.define do
  factory :bulk_discount do
    percent_discount {Faker::Number.number(digits: 2)}
    quantity_threshold {Faker::Number.number(digits: 2)}
    association :merchant
  end
end