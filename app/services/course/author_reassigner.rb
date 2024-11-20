# frozen_string_literal: true

class Course
  class AuthorReassigner
    attr_reader :course

    def initialize(course)
      @course = course
    end

    def call
      return if course.competencies.count.zero?

      course.update(author: author_for_reassign)
    end

    private

    def author_gateway
      Author
    end

    def author_for_reassign
      best_match_authors.exists? ? best_match_authors.first : author_gateway.where.not(id: course.author_id).first
    end

    def best_match_authors
      author_gateway
        .joins(:competencies)
        .where(competencies: course.competencies)
        .where.not(id: course.author_id)
        .group('id')
        .order('count(competencies.id) DESC')
    end
  end
end
