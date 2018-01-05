class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.string :title
      t.boolean :is_completed, default: false

      t.timestamps null: false
    end
  end
end
