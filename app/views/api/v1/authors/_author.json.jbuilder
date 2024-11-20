# frozen_string_literal: true

json.extract! author, :id, :name
if author.competencies.present?
  json.competencies do
    json.array! author.competencies, partial: 'api/v1/competencies/competency', as: :competency
  end
end
