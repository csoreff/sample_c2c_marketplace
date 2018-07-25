FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "product_#{n}" }
    description "Description"
    cost 100
    user
    status 0
  end
end
