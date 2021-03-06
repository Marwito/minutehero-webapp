FactoryGirl.define do
  factory :user do
    confirmed_at Time.now
    first_name 'Test'
    last_name 'User'
    sequence(:email) { |n| "test#{n}@example.com" }
    password '1234567='

    trait :admin do
      role 'admin'
    end
  end
end
