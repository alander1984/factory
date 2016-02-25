class OperationsController < ApplicationController
  before_action :set_operation, only: [:show, :edit, :update, :destroy]
  before_action :set_op_costs, only: [:create]
before_filter :authenticate_user!
  # GET /operations
  # GET /operations.json
  def index
    @operations = Operation.where("isactive=true")
  end

  # GET /operations/1
  # GET /operations/1.json
  def show
    @cur_operation_costs=OperationCost.where("operation_id = :id",{id: params[:id]})
  end

  # GET /operations/new
  def new
    @operation = Operation.new
    @workshops = Workshop.all
    @cur_operation_costs = [];
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /operations/1/edit
  def edit
    @cur_operation_costs=OperationCost.where("operation_id = :id",{id: params[:id]})
    @workshops = Workshop.all
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /operations
  # POST /operations.json
  def create
    @operation = Operation.new(operation_params)

    respond_to do |format|
      if @operation.save
        format.html { redirect_to @operation, notice: 'Операция успешно создана.' }
        format.json { render :show, status: :created, location: @operation }
      else
        format.html { render :new }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /operations/1
  # PATCH/PUT /operations/1.json
  def update
    respond_to do |format|
      if @operation.update(operation_params)
        format.html { redirect_to @operation, notice: 'Операция успешно изменена.' }
        format.json { render :show, status: :ok, location: @operation }
      else
        format.html { render :edit }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operations/1
  # DELETE /operations/1.json
  def destroy
    @operation.isactive=false;
    @operation.save;
    respond_to do |format|
      format.html { redirect_to operations_url, notice: 'Операция успешно удалена.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operation
      @operation = Operation.find(params[:id])
    end

    def set_op_costs
      @cur_operation_costs=OperationCost.where("operation_id = :id",{id: params[:id]})
    end  

    # Never trust parameters from the scary internet, only allow the white list through.
    def operation_params
      params.require(:operation).permit(:name, :special, :workshop_id, :isactive)
    end
end
