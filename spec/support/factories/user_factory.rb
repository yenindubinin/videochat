FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@lawdingo.com"
  end

  factory :user do
    first_name "Thome"
    last_name "York"
    email { Faker::Internet.email }
    password "secret"
    user_type{User::CLIENT_TYPE}
    phone '+0123456789'
  end

  factory :client do
    first_name "Thome"
    last_name "York"
    email { Faker::Internet.email }
    password "secret"
    user_type{User::CLIENT_TYPE}
    phone '+0123456789'
  end
  
  factory :admin do
    first_name "Thome"
    last_name "York"
    email { Faker::Internet.email }
    password "secret"
    user_type{User::ADMIN_TYPE}
    phone '+0123456789'
  end
end
