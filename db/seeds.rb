# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#create users
300.times do |index|
  puts "User #{index}"
  user_detail = UserDetail.new(
                              first_name: FFaker::Name.first_name,
                              last_name: FFaker::Name.last_name,
                              organization: FFaker::Company.name,
                              title: FFaker::Company.position,
                              website_url: FFaker::Internet.http_url,
                              linkedin_url: FFaker::Internet.http_url
  )
  user = User.new(
                 email: FFaker::Internet.email,
                 password: 'password',
                 confirmed_at: Time.now,
                 user_detail: user_detail
  )
  user.skip_confirmation!
  user.save!
end



#create questions
5000.times do |index|
  puts "Question #{index}"
  question = Question.new(
                         title: FFaker::Lorem.sentence(20),
                         body: FFaker::HTMLIpsum.p(rand(1..10)),
                         jurisdiction: Question.jurisdictions.keys.sample,
                         tags: rand(0..15).times.collect { Tag.find_or_create_by(name: FFaker::Lorem.word) },
                         user: User.order("RANDOM()").first
  )
  question.created_at = (rand*3000).days.ago
  question.save!
end

Question.all.each do |question|
  puts "Voting on question #{question.id}"
  users = User.order("RANDOM()").limit(200)
  rand(0..200).times do |index|
    question.votes << Vote.new(user_id: users[index].id, value: [-1,1].sample)
  end
  question.save!
end

Question.all.each do |question|
  puts "Answering question #{question.id}"
  users = User.order("RANDOM()").limit(6)
  rand(0..6).times do |index|
    answer = Answer.new(user_id: users[index].id, body: FFaker::HTMLIpsum.p(rand(1..10)))
    answer.created_at = rand(question.created_at..Time.now)
  end
  question.save!
end

Question.all.each do |question|
  question.answers.each do |answer|
    puts "Voting on answer #{answer.id} to question #{question.id}"
    users = User.order("RANDOM()").limit(200)
    rand(0..200).times do |index|
      answer.votes << Vote.new(user_id: users[index].id, value: [1,-1].sample)
    end
    answer.save!
  end
  question.save!
end
