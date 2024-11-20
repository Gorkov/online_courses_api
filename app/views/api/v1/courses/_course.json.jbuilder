# frozen_string_literal: true

json.extract! course, :id, :title, :description
json.author do
  json.partial! 'api/v1/authors/author', author: course.author
end
if course.competencies.present?
  json.competencies do
    json.array! course.competencies, partial: 'api/v1/competencies/competency', as: :competency
  end
end
