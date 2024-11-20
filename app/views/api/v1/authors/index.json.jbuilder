# frozen_string_literal: true

json.collection do
  json.array! @authors, partial: 'api/v1/authors/author', as: :author
end
if @authors.present?
  json.paging do
    json.total_count @pagy_metadata[:count]
    json.current_page @pagy_metadata[:page]
    json.next_page @pagy_metadata[:next] if @pagy_metadata[:next].present?
  end
end
