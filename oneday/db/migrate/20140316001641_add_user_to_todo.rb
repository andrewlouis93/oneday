class AddUserToTodo < ActiveRecord::Migration
  def change
    add_column :todos, :user, :string
  end
end
