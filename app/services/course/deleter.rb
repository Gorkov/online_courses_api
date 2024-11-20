# frozen_string_literal: true

class Course
  class Deleter
    include Transactionable

    attr_reader :course

    def initialize(course)
      @course = course
    end

    def call
      return if course.deleted_at

      deleted_at = Time.current
      course.update(deleted_at: deleted_at)
      course.course_competencies.update_all(deleted_at: deleted_at)
    end
  end
end
