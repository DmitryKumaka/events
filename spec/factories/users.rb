FactoryGirl.define do
  factory :user do
    email 'user@test.com'
    password '12345678'
  end

  factory :second_user, class: User do
    email 'user2@test.com'
    password '12345678'
  end
end
