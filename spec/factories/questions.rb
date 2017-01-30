FactoryGirl.define do

  factory :question do
    title {FFaker::Lorem.sentence(15)}
    body {FFaker::HTMLIpsum.p(3)}
    jurisdiction  {Question.jurisdictions.keys.sample}
    after(:create) {|q| q.tags = rand(1..20).times.collect { create(:tag) }}
    user
  end
end