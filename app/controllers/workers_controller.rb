class WorkersController < ApplicationController
  require 'barby'
  require 'barby/barcode/code_128'
  require 'barby/outputter/png_outputter'
  require 'active_support'
  before_filter :authenticate_user!, :except => ["period"]
  

  before_action :set_worker, only: [:show, :edit, :update, :destroy, :period]

  # GET /workers
  # GET /workers.json
  def index
    @workers = Worker.order("fname, sname, tname").where("isactive=true");
  end

  # GET /workers/1
  # GET /workers/1.json
  def show
    @code =(31536000*50+@worker.birthday.to_time(:utc).to_i)*1000+@worker.id+@worker.pin;
    @barcode = Barby::Code128.new(@code.to_s)
    data_binary = @barcode.to_png({:height => 20, :margin => 0})
    @data_base64 = Base64.encode64(data_binary).gsub("\n","")
  end

  # GET /workers/new
  def new
    @worker = Worker.new
  end

  # GET /workers/1/edit
  def edit
  end

  # POST /workers
  # POST /workers.json
  def create
    @worker = Worker.new(worker_params)
    @worker.pin=100000+Random.rand(899999);
    

    respond_to do |format|
      if @worker.save
        format.html { redirect_to @worker, notice: 'Сотрудник успешно зарегистрирован.' }
        format.json { render :show, status: :created, location: @worker }
      else
        format.html { render :new }
        format.json { render json: @worker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workers/1
  # PATCH/PUT /workers/1.json
  def update
    respond_to do |format|
      if @worker.update(worker_params)
        format.html { redirect_to @worker, notice: 'Worker was successfully updated.' }
        format.json { render :show, status: :ok, location: @worker }
      else
        format.html { render :edit }
        format.json { render json: @worker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workers/1
  # DELETE /workers/1.json
  def destroy
    temps =@worker.fname
    @worker.isactive=false;
    @worker.save;
    respond_to do |format|
      format.html { redirect_to workers_url, notice: 'Сотрудник '+temps+' успешно деактивирован :(' }
      format.json { head :no_content }
    end
  end

    def showstat
=begin
      Этот код не работает
      set_worker();
      @worker_name=@worker.fname+' '+@worker.sname+' '+@worker.tname;
      groupedActions=Action.joins(:operation).joins(:workshop).
        group('date(actions.created_at)','operations.id', 'operations.name', 'workshops.id', 'workshops.name').
        where("worker_id=:worker_id",
          {worker_id: params[:id]}).
      order('date(actions.created_at)').
      sum('actions.cnt');
      @worker_stat=Array.new(groupedActions.length, Hash.new);
      i=0; @sum=0;
      groupedActions.each do |ga|
        @worker_stat[i]['cnt']=ga[1];
        @worker_stat[i]['action_date']=ga[0][0];
        @worker_stat[i]['operation_name']=ga[0][2];
        @worker_stat[i]['workshop_name']=ga[0][4];
        @sum=@sum+ga[1];
        i=i+1;
      end 
=end
    end

    def period
      puts case params['period']
      when 'today'
        @dayinfo = Array.new(1) {Hash.new};
        @dayinfo[0]['day']=Date.today;
        sdate = Date.today;
        edate=sdate+1;
      when 'yesterday'
        @dayinfo = Array.new(1) {Hash.new};
        @dayinfo[0]['day']=Date.today-1;
        sdate = Date.today-1;
        edate=sdate+1;
      when 'thisweek'  
        @dayinfo = Array.new(7) {Hash.new};
        sdate = Date.today-Date.today.wday+1;
        edate = sdate+7;
        for i in 0..6
          @dayinfo[i]['day']=sdate+i;
        end  
      when 'lastweek'
        @dayinfo = Array.new(7) {Hash.new};
        sdate = Date.today-Date.today.wday-6;
        edate = sdate+7;
        for i in 0..6
          @dayinfo[i]['day']=sdate+i;
        end  
      when 'thismonth'
         sdate = Date.today.beginning_of_month;
         edate = Date.today.end_of_month;
         l = edate-sdate+1;
         logger.info('sdate='+sdate.to_s+' edate='+edate.to_s+' l='+l.to_s)
         @dayinfo = Array.new(l) {Hash.new};
         for i in 0..l-1
            @dayinfo[i]['day']=sdate+i;
         end  
      when 'lastmonth'
         sdate = Date.today.months_ago(1).beginning_of_month;
         edate = Date.today.months_ago(1).end_of_month;
         l = edate-sdate+1;
         logger.info('sdate='+sdate.to_s+' edate='+edate.to_s+' l='+l.to_s)
         @dayinfo = Array.new(l) {Hash.new};
         for i in 0..l-1
            @dayinfo[i]['day']=sdate+i;
         end  
      else
        #неизвестно
      end  
      @eCount = 0;
      @totalAmount = 0;
      groupedActions = Action.select('sum(cnt) as cnt, cost, sum(amount) as amount, operations.name, date(actions.created_at)').joins(:operation).
        group('date(actions.created_at)', 'operations.name', 'cost').
        where("worker_id=:worker_id and actions.created_at between :start_date and :end_date and coalesce(special,0)<>1" ,
          {worker_id: params[:id], start_date: sdate, end_date: edate}).order('date(actions.created_at)');
      groupedSpecialActions = Action.select('sum(cnt) as cnt, cost, sum(amount) as amount, operations.name, date(actions.created_at)').joins(:operation).group('date(actions.created_at)', 'operations.name', 'cost').where("linkedworker_id=:worker_id and actions.created_at between :start_date and :end_date and special=1",
          {worker_id: params[:id], start_date: sdate, end_date: edate}).order('date(actions.created_at)');
      groupedActions.each do |ga|
        info = @dayinfo.select{|info| info['day']==ga.date}.first();
        if !info .nil?
          if info['detail'].nil? 
            info['detail'] = Array.new(0);
            @eCount += 1;
          end;  
          @eCount +=1; 
          element = Hash.new;#info['detail'].last;
          element['cnt']=ga.cnt;
          element['cost']=ga.cost;
          element['amount']=ga.amount;
          element['operation_name']=ga.name;
          element['date']=ga.date.to_s;
          @totalAmount = @totalAmount +ga.amount; 
          if info['amount'].nil?
            info['amount'] = ga.amount
          else  
            info['amount'] = info['amount']+ga.amount;
          end  
          info['detail'] << element;
        end  
      end

      groupedSpecialActions.each do |ga|
        info = @dayinfo.select{|info| info['day']==ga.date}.first();
        if !info .nil?
          if info['detail'].nil? 
            info['detail'] = Array.new(0);
            @eCount +=1;
          end;  
          @eCount += 1;
          element = Hash.new;#info['detail'].last;
          element['cnt']=ga.cnt;
          element['cost']=ga.cost;
          element['amount']=ga.amount;
          element['operation_name']=ga.name;
          element['date']=ga.date.to_s;
          @totalAmount = @totalAmount -ga.amount; 
          if info['amount'].nil? 
            info['amount'] = ga.amount
          else  
            info['amount'] = info['amount']-ga.amount;
          end  
          info['detail'] << element;
        end  
      end
    end  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_worker
      @worker = Worker.find(params[:id]);
      case params[:month] 
      when '01' then mname='январь'
      when '02' then mname='февраль'
      when '03' then mname='март'
      when '04' then mname='апрель'
      when '05' then mname='май'
      when '06' then mname='июнь'
      when '07' then mname='июль'
      when '08' then mname='август'
      when '09' then mname='сентябрь'
      when '10' then mname='октябрь'
      when '11' then mname='ноябрь'
      when '12' then mname='декабрь';
   end;  
      @month_name=mname;
        
end

    # Never trust parameters from the scary internet, only allow the white list through.
    def worker_params
      params.require(:worker).permit(:fname, :sname, :tname, :birthday, :pin, :isactive)
    end
    
      
    
end
