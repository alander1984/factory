class ActionsController < ApplicationController
	before_action :set_action, only: [:show, :updateCnt, :updateCost]
	skip_before_action :verify_authenticity_token
	respond_to :html, :json
	
	def show 
	
	end

	def create
		@action = Action.new;
		@action.save
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

	def addCustomAction
		@action = Action.new(worker_id: params['worker_id'])
		@operations = Operation.all;
		@workshops = Workshop.all
	end


	private
		def set_action
			@action = Action.find(params[:id]);
		end	
	
		def action_params 
			params.require(:action).permit(:cnt,:cost,:created_at,:amount,:operation_id) 
		end
end	