# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :courses, -> { where(deleted_at: nil) }
  has_many :author_competencies, -> { where(deleted_at: nil) }, dependent: :destroy
  has_many :competencies, -> { where(deleted_at: nil) }, through: :author_competencies
end
