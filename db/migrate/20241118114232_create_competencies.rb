class CreateCompetencies < ActiveRecord::Migration[7.1]
  def change
    create_table :competencies do |t|
      t.string :description, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
