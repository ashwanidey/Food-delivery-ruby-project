FactoryBot.define do
  factory :user do
    email { "ashwanidey02@gmail.com" }
    password { "123456" }
    phone_number { "1234567890" }
    role { "restaurant_admin" }
    name { "Ashwani Dey" }
  end
end
