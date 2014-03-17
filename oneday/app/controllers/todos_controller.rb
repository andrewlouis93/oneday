class TodosController < ApplicationController

	def index
		@todo = Todo.new
		@todos = Todo.where(done:false,user:current_user.email)
		@todones = Todo.where(done:true,user:current_user.email)
	end

	def new
		@todo = Todo.new
	end

	def todo_params
		params.require(:todo).permit(:name, :done, :user)
	end

	# POST call to Todos goes here. This is why the form submit goes here on submission. http://stackoverflow.com/a/2472489/765409
	def create
		@todo = Todo.new(todo_params)
	    respond_to do |format|
	        if @todo.save
	            format.js
	            format.html { redirect_to todos_path, :notice => "Your todo item was created!" }
	        else
	            render "new"
	        end
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
