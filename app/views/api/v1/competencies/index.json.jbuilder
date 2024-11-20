# frozen_string_literal: true

json.collection do
  json.array! @competencies, partial: 'api/v1/competencies/competency', as: :competency
end
if @competencies.present?
  json.paging do
    json.total_count @pagy_metadata[:count]
    json.current_page @pagy_metadata[:page]
    json.next_page @pagy_metadata[:next] if @pagy_metadata[:next].present?
  end
end
