class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
