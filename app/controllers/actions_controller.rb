class ActionsController < ApplicationController
	before_action :set_action, only: [:show, :updateCnt, :updateCost]
	skip_before_action :verify_authenticity_token
	respond_to :html, :json
	
	def show 
	
	end

	
	def updateCnt
		@action.cnt = params['cnt']
		@action.amount=(@action.cost*@action.cnt).round(2)
		@action.save
	end

	def updateCost
		@action.cost = params['cost']
		@action.amount=(@action.cost*@action.cnt).round(2)

		@action.save
	end


	private
		def set_action
			@action = Action.find(params[:id]);
		end	
	
		def action_params 
			params.require(:action).permit(:cnt,:cost) 
		end
end	