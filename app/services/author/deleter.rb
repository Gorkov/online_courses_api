# frozen_string_literal: true

class Author
  class Deleter
    include Transactionable

    attr_reader :author

    def initialize(author)
      @author = author
    end

    def call
      return if author.deleted_at

      transaction do
        reassign_courses
        mark_as_deleted
      end
    end

    private

    def author_reassigner
      Course::AuthorReassigner
    end

    def reassign_courses
      author.courses.each { |course| author_reassigner.new(course).call }
    end

    def mark_as_deleted
      deleted_at = Time.current
      author.update(deleted_at: deleted_at)
      author.author_competencies.update_all(deleted_at: deleted_at)
    end
  end
end
