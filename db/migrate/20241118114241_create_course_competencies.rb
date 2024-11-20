class CreateCourseCompetencies < ActiveRecord::Migration[7.1]
  def change
    create_table :course_competencies do |t|
      t.references :course, null: false, foreign_key: true
      t.references :competency, null: false, foreign_key: true
      t.datetime :created_at, null: false
      t.datetime :deleted_at
    end

    add_index :course_competencies, [:course_id, :competency_id], unique: true
  end
end
