class ActionsController < ApplicationController
	before_action :set_action, only: [:show, :updateCnt, :updateCost]
	skip_before_action :verify_authenticity_token
	respond_to :html, :json
	before_filter :authenticate_user!

	def new
		@operations = Operation.where('coalesce(special,0)<>1')
		@workshops = Workshop.all
		@workers = Worker.where("isactive = true").order('workers.fname')
		@act = Action.new
	end	

	def create
		@action = Action.new
		@action.cnt = params['cnt'];
		@action.amount = params['amount']
		@action.cost = params['cost'];
		@action.operation_id=params['operation_id']
		@action.worker_id=params['worker_id'];
		@action.created_at=Date.strptime(params['regdate'],'%m/%d/%Y') rescue nil
		if @action.save
			respond_to do |format|	
       			format.html { redirect_to report_showstat1_path, notice: 'Действие зарегистрировано.' }
       		end	
       	end	
	end	

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

	def addCustomAction
		@action = Action.new
	end

	def saveCustomAction
	end	

	private
		def set_action
			@action = Action.find(params[:id]);
		end	
	
		def action_params 
			params.require(:action).permit(:cnt,:cost,:created_at,:amount,:operation_id) 
		end
end	