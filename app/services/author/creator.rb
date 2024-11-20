# frozen_string_literal: true

class Author
  class Creator
    include Transactionable

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      transaction do
        author = author_gateway.create(params.except(:competency_ids))
        author.competencies << competencies_for_add if params[:competency_ids]
        author
      end
    end

    private

    def author_gateway
      Author
    end

    def competency_gateway
      Competency
    end

    def competencies_for_add
      competency_gateway.where(id: params[:competency_ids])
    end
  end
end
