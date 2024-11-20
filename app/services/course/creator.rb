# frozen_string_literal: true

class Course
  class Creator
    include Transactionable

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      transaction do
        course = course_gateway.create(params.except(:competency_ids))
        course.competencies << competencies_for_add if params[:competency_ids]

        course
      end
    end

    private

    def course_gateway
      Course
    end

    def competency_gateway
      Competency
    end

    def competencies_for_add
      competency_gateway.where(id: params[:competency_ids])
    end
  end
end
