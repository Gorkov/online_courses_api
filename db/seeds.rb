return unless Rails.env.development? || Rails.env.test?

authors = Author.create(
  [
    { name: 'Author 1' },
    { name: 'Author 2' },
    { name: 'Author 3' },
    { name: 'Author 4' },
    { name: 'Author 5' }
  ]
)
competencies = Competency.create(
  [
    { description: Faker::Educator.subject },
    { description: Faker::Educator.subject },
    { description: Faker::Educator.subject }
  ]
)

10.times do
  author = authors.sample

  course = Course.create(
    title: Faker::Educator.degree,
    description: Faker::Educator.course_name,
    author: author
  )

  course_competencies = [true, false].sample ? [competencies.sample] : competencies
  course.competencies << course_competencies if [true, false].sample

  next if author.competencies.exists?

  author_competencies = [true, false].sample ? [competencies.sample] : competencies
  author.competencies << author_competencies if [true, false].sample
end