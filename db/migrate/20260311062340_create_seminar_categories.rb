class CreateSeminarCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :seminar_categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :color, default: "#3B82F6"

      t.timestamps
    end
    add_index :seminar_categories, :slug, unique: true
  end
end
