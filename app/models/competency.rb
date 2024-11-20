class Competency < ApplicationRecord
  has_many :course_competencies, -> { where(deleted_at: nil) }, dependent: :destroy
  has_many :courses, through: :course_competencies
  has_many :author_competencies, -> { where(deleted_at: nil) }, dependent: :destroy
  has_many :authors, through: :author_competencies
end
