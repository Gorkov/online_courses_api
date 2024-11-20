class CourseCompetency < ApplicationRecord
  belongs_to :course
  belongs_to :competency
end
