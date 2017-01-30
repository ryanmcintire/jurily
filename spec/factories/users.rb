FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password 'abcd1234'
    confirmed_at Time.now
    user_detail

    after(:create) do |user, evaluator|
      create_list(:question, rand(0..10), user: user)
    end
  end

  factory :user_detail do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    organization { FFaker::Company.name }
    title { FFaker::Company.position }
    website_url { FFaker::Internet.http_url }
    linkedin_url { FFaker::Internet.http_url }
  end
end