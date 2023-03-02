FactoryBot.define do
  factory :invoice_item do
    percent_discount {Faker::Number.number(digits: 2)}
    quantity_threshold {Faker::Number.number(digits: 2)}
    association :merchant
  end
end