# frozen_string_literal: true

class Author
  class Updater
    include Transactionable

    attr_reader :author, :params

    def initialize(author, params)
      @author = author
      @params = params
    end

    def call
      transaction do
        author.update(params.except(:competency_ids))

        update_competencies if params[:competency_ids]
      end
    end

    private

    def competency_gateway
      Competency
    end

    def update_competencies
      new_competencies = competencies_for_add
      new_competencies = competencies_for_add - author.competencies if author.competencies.exists?

      return if new_competencies.blank?

      author.competencies << new_competencies
    end

    def competencies_for_add
      competency_gateway.where(id: params[:competency_ids])
    end
  end
end
