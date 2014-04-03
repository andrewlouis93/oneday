class TodosController < ApplicationController

	def index
		@todo = Todo.new
		@todos = Todo.where(done:false,user:current_user.email)
		@todones = Todo.where(done:true,user:current_user.email).order('updated_at DESC')
		@todones = @todones.where("updated_at >= ?", Time.zone.now.beginning_of_day)
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


	# Could add another parms argument, and change what update does depending on this argument?
	def update
		@todo = Todo.find(params[:id])

	    respond_to do |format|
			if @todo.done
				@todo.update_attribute(:done, false)
				format.js
	            format.html {redirect_to todos_path, :notice => "Your todo item was marked done!"}
			elsif @todo.done == false
				@todo.update_attribute(:done, true)
	            format.js
	            format.html {redirect_to todos_path, :notice => "Your todo item was marked done!"}				
			else
	            redirect_to todos_path, :notice => "Couldn't update your task"
			end	    	
	    end
	end

	def destroy
		@todo = Todo.find(params[:id])

	    respond_to do |format|
	   	  format.js
	      format.html { redirect_to todos_path, :notice => "Your todo item was deleted" }
	    end

	    @todo.destroy
	end

	def about
	end

	def sort
		@todos = Todo.where(done:false,user:current_user.email)
		@todos.each do |todo|
			todo.position = params['todo'].index(todo.id.to_s) + 1
			todo.save
		end
		render :nothing => true
	end

	def stats
		@today_data = Todo.where(done:true,user:current_user.email).where("updated_at >= ?", Time.zone.now.beginning_of_day)
		@today = Todo.where(done:true,user:current_user.email).where("updated_at >= ?", Time.zone.now.beginning_of_day).size
		
		@week_data = Todo.where(done:true,user:current_user.email).where("updated_at >= ?", 7.days.ago)
		@week = Todo.where(done:true,user:current_user.email).where("updated_at >= ?", 7.days.ago).size
		
		@year_data = Todo.where(done:true,user:current_user.email).where("updated_at >= ?", Time.zone.now.beginning_of_year)
		@year = Todo.where(done:true,user:current_user.email).where("updated_at >= ?", Time.zone.now.beginning_of_year).size
	end
end
