class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :title, null: false
      t.text :description
      t.references :author, null: false, foreign_key: true
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
