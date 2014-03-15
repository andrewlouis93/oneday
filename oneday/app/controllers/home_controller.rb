class HomeController < ApplicationController
	def index
		# user_signed_in is a default function from devise
		if user_signed_in?
			# if user is signed in, go to the todo controller, and the action index
			redirect_to :controller => 'todos', :action => 'index'
		end
	end
end
