# frozen_string_literal: true

class Course
  class Updater
    include Transactionable

    attr_reader :course, :params

    def initialize(course, params)
      @course = course
      @params = params
    end

    def call
      transaction do
        course.update(params.except(:competency_ids))
        update_competencies if params[:competency_ids]
      end
    end

    private

    def competency_gateway
      Competency
    end

    def update_competencies
      new_competencies = competencies_for_add
      new_competencies = competencies_for_add.difference(course.competencies) if course.competencies.exists?

      return if new_competencies.blank?

      course.competencies << new_competencies
    end

    def competencies_for_add
      competency_gateway.where(id: params[:competency_ids])
    end
  end
end
