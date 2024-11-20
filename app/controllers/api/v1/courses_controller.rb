# frozen_string_literal: true

module Api
  module V1
    class CoursesController < ApplicationController
      include Pagy::Backend

      before_action :set_course, only: %i[show update destroy]

      def index
        @pagy, @courses = pagy(course_gateway.where(deleted_at: nil).order(:id))
        @pagy_metadata = pagy_metadata(@pagy)
      end

      def show
        render status: :not_found unless @course

        @course
      end

      def create
        @course = course_creator.new(course_params).call

        render @course, status: :created
      rescue StandardError
        head :unprocessable_entity
      end

      def update
        course_updater.new(@course, course_params).call

        @course
      rescue StandardError
        render @course, status: :unprocessable_entity
      end

      def destroy
        render status: :not_found unless @course

        course_deleter.new(@course).call

        head :no_content
      rescue StandardError
        render @course, status: :unprocessable_entity
      end

      private

      def course_gateway
        Course
      end

      def set_course
        @course = course_gateway.includes(:competencies).where(deleted_at: nil).find(params[:id])
      end

      def course_params
        params.permit(:title, :description, :author_id).merge!(competency_ids: params[:competency_ids])
      end

      def course_creator
        Course::Creator
      end

      def course_updater
        Course::Updater
      end

      def course_deleter
        Course::Deleter
      end
    end
  end
end
