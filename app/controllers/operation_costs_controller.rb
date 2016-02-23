class OperationCostsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_operation_cost, only: [:show, :edit, :update, :destroy]
  respond_to :html, :js


  def new
  	@operation_cost = OperationCost.new;
  end

  def create
    @operation_id=params[:operation_cost][:operation_id];
    #l = Logger.new(STDOUD);
    #l.info('OPERID   '+@operation_id);
  	@operation_cost = OperationCost.new(operation_cost_params);
  	@operation_cost.save;
    #@operation = Operation.where("id = :id",{id: params[:operation_id]});
  	respond_to do |format|
      format.js {}
      #format.html { redirect_to edit_operation_path(operation_cost_params[:operation_id])}
    end  
  end	

  def destroy
    OperationCost.destroy(params[:id]);
    respond_to do |format|
      format.js {}  
    end
  end 

  def cur_operation_cost
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operation_cost
      @operationcost = OperationCost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def operation_cost_params
      params[:operation_cost].permit( :sdate, :edate, :cost, :operation_id)
    end

end