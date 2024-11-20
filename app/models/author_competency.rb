class AuthorCompetency < ApplicationRecord
  belongs_to :author
  belongs_to :competency
end
