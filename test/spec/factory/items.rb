FactoryBot.define do
  factory :item do
    name { "Panner" }
    description { "A delicious paneer dish" }
    price { 100 }
    category { "Side Dish" }
    association :restaurant, factory: :restaurant
  end
end
