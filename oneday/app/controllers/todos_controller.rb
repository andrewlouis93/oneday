class TodosController < ApplicationController

	def index
		@todo = Todo.new
		@todos = Todo.where(done:false,user:current_user.email).order('position ASC')
		@todones = Todo.where(done:true,user:current_user.email).order('updated_at DESC')
		@todones = @todones.where("updated_at >= ?", Time.now.beginning_of_day)
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

		@today_data = Todo.where(done:true,user:current_user.email).where("updated_at >= :start_date AND updated_at <= :end_date", {start_date: Time.zone.now.beginning_of_day, end_date: Time.zone.now.end_of_day})		
		@week_data = Todo.where(done:true,user:current_user.email).where("updated_at >= :week_bound AND updated_at <= :end_date", {week_bound: Time.zone.now.advance({days: -7}), end_date: Time.zone.now.end_of_day})
		@month_data = Todo.where(done:true,user:current_user.email).where("updated_at >= :start_date AND updated_at <= :end_date", {start_date: Time.zone.now.beginning_of_year, end_date: Time.zone.now.end_of_day})

		@past_week_data = Array.new()
		4.times do |i|
			@past_week_data.push(Todo.where(done:true,user:current_user.email).where("updated_at >= :week_bound AND updated_at <= :end_date", { week_bound: Date.today.beginning_of_week - (7*i).days, end_date: Date.today.end_of_week - (7*i).days }))
		end

		@this_year_data = Array.new()
		Date.today.month.downto(1) do |i|
			@this_year_data.push(  Todo.where(done:true,user:current_user.email).where("updated_at >= :week_bound AND updated_at <= :end_date", { week_bound: Date.today.beginning_of_month - (4 - 1*i).month, end_date: Date.today.end_of_month - (4 - 1*i).month })  )
		end

	end
end
