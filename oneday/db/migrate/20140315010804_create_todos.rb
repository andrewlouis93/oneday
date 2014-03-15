class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :name
      t.string :start_time
      t.string :finish_time
      t.boolean :done

      t.timestamps
    end
  end
end
