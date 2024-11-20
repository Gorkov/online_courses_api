class Course < ApplicationRecord
  belongs_to :author, -> { where(deleted_at: nil) }
  has_many :course_competencies, -> { where(deleted_at: nil) }, dependent: :destroy
  has_many :competencies, -> { where(deleted_at: nil) }, through: :course_competencies
end
