# frozen_string_literal: true

json.collection do
  json.array! @courses, partial: 'api/v1/courses/course', as: :course
end
json.paging do
  json.extract! @pagy_metadata, :count, :page, :next
end
