# frozen_string_literal: true

module Api
  module V1
    class AuthorsController < ApplicationController
      include Pagy::Backend

      before_action :set_author, only: %i[show update destroy]

      def index
        @pagy, @authors = pagy(author_gateway.where(deleted_at: nil).order(:id))
        @pagy_metadata = pagy_metadata(@pagy)
      end

      def show
        render status: :not_found unless @author

        @author
      end

      def create
        @author = author_creator.new(author_params).call

        render @author, status: :created
      rescue StandardError
        head :unprocessable_entity
      end

      def update
        render status: :not_found unless @author

        author_updater.new(@author, author_params).call

        @author
      rescue StandardError
        render @author, status: :unprocessable_entity
      end

      def destroy
        render status: :not_found unless @author

        author_deleter.new(@author).call

        head :no_content
      rescue StandardError
        render @author, status: :unprocessable_entity
      end

      private

      def author_gateway
        Author
      end

      def set_author
        @author = author_gateway.includes(:competencies).where(deleted_at: nil).find(params[:id])
      end

      def author_params
        params.permit(:name).merge!(competency_ids: params[:competency_ids])
      end

      def author_creator
        Author::Creator
      end

      def author_updater
        Author::Updater
      end

      def author_deleter
        Author::Deleter
      end
    end
  end
end
