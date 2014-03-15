class TodosController < ApplicationController

	def index
		@todos = Todo.where(done:false)
		@todones = Todo.where(done:true)
	end

	def new
		@todo = Todo.new
	end

	def todo_params
		params.require(:todo).permit(:name, :done)
	end

	def create
		@todo = Todo.new(todo_params)
		if @todo.save
			redirect_to todos_path, :notice => "Your todo item was created!"
		else
			render "new"
		end
	end

	def update
		@todo = Todo.find(params[:id])

		if @todo.update_attribute(:done, true)
			redirect_to todos_path, :notice => "Your todo item was marked done!"
		else
			redirect_to todos_path, :notice => "Couldn't update your task"
		end
	end

	def destroy
		@todo = Todo.find(params[:id])
		@todo.destroy

		redirect_to todos_path, :notice => "Your todo item was deleted"
	end

end
