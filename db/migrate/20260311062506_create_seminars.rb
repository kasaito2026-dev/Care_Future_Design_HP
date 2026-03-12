class CreateSeminars < ActiveRecord::Migration[7.2]
  def change
    create_table :seminars do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description
      t.date :seminar_date
      t.string :location
      t.integer :capacity
      t.references :seminar_category, foreign_key: true
      t.boolean :is_published, default: false, null: false

      t.timestamps
    end
    add_index :seminars, :slug, unique: true
    add_index :seminars, :seminar_date
  end
end
