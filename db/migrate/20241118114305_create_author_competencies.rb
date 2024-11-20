class CreateAuthorCompetencies < ActiveRecord::Migration[7.1]
  def change
    create_table :author_competencies do |t|
      t.references :author, null: false, foreign_key: true
      t.references :competency, null: false, foreign_key: true
      t.datetime :created_at, null: false
      t.datetime :deleted_at
    end

    add_index :author_competencies, [:author_id, :competency_id], unique: true
  end
end
