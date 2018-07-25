FactoryBot.define do
  factory :purchase do
    amount 100
    user
    product
  end
end
