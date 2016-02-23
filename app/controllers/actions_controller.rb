class ActionsController < ApplicationController
	before_action :set_action, only: [:show]

	def show 
	end
	
	private
		def set_action
			@action = Action.find(params[:id]);
		end	
	
end	