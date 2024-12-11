class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.timestamps
    end

    create_table :categories_tasks, id: false do |t|
      t.belongs_to :task
      t.belongs_to :category
    end
  end
end
