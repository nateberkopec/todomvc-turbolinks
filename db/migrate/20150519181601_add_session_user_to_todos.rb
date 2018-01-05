class AddSessionUserToTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :session_user_id, :string
  end
end
