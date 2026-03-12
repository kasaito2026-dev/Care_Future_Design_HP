class CreateActivityReports < ActiveRecord::Migration[7.2]
  def change
    create_table :activity_reports do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :content
      t.datetime :published_at
      t.boolean :is_published, default: false, null: false

      t.timestamps
    end
    add_index :activity_reports, :slug, unique: true
  end
end
