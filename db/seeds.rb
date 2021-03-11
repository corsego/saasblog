10.times do
  Post.create(
    title: Faker::Lorem.sentence(word_count: 3),
    content: Faker::Lorem.sentence,
    premium: [true, false].sample
  )
end
