# frozen_string_literal: true

module Api
  module V1
    class CompetenciesController < ApplicationController
      include Pagy::Backend

      before_action :set_competency, only: %i[show update destroy]

      def index
        @pagy, @competencies = pagy(competency_gateway.where(deleted_at: nil).order(:id))
        @pagy_metadata = pagy_metadata(@pagy)
      end

      def show
        render status: :not_found unless @competency

        @competency
      end

      def create
        @competency = competency_gateway.new(competency_params)

        if @competency.save
          render @competency, status: :created
        else
          render json: @competency.errors, status: :unprocessable_entity
        end
      end

      def update
        render status: :not_found unless @competency

        return @competency if @competency.update(competency_params)

        render json: @competency.errors, status: :unprocessable_entity
      end

      def destroy
        render status: :not_found unless @competency

        @competency.update!(deleted_at: Time.current)

        head :no_content
      end

      private

      def competency_gateway
        Competency
      end

      def set_competency
        @competency = competency_gateway.where(deleted_at: nil).find(params[:id])
      end

      def competency_params
        params.permit(:title, :description)
      end
    end
  end
end
