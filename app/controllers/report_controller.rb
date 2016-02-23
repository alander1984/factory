class ReportController < ApplicationController

require 'csv'  
  
  def index
    @groupedActions=Action.joins(:operation).joins(:worker).joins(:workshop).
        group('date(actions.created_at)','operations.id', 'operations.name', 'workers.id', 'workshops.id', 'workshops.name').
     # where("actions.created_at >= :start_date AND actions.created_at <= :end_date",
     #{start_date: params[:start_date], end_date: params[:end_date]}).
    order('date(actions.created_at)').
    sum('actions.cnt')
#    respond_to do |format|
#      format.html
#      format.xls { send_data to_csv(col_sep: ",") }
#    end
  end

  def getStat1

      groupedActions = Action.select('sum(amount) as amount, workers.id, workers.fname, workers.sname, workers.tname, workers.birthday').joins(:worker).joins(:operation).
        group('workers.fname','workers.sname','workers.tname','workers.birthday', 'workers.id').
        where("actions.created_at between :start_date and :end_date and coalesce(special,0)<>1" ,
          {start_date: @sdate, end_date: @edate}).order('workers.fname');
      groupedSpecialActions = Action.select('sum(amount) as amount, workers.id, workers.fname, workers.sname, workers.tname, workers.birthday').joins(:linkedworker).joins(:operation).
        group('workers.fname','workers.sname','workers.tname','workers.birthday', 'workers.id').where("actions.created_at between :start_date and :end_date and operations.special=1",{start_date: @sdate, end_date: @edate});
      #    {worker_id: params[:id], start_date: sdate, end_date: edate}).order('date(actions.created_at)');
      @winfo = Array.new(0);
      groupedActions.each do |ga|
          element = Hash.new;
          element['amount']=ga.amount;
          element['fname']=ga.fname;
          element['sname']=ga.sname;
          element['tname']=ga.tname;
          element['birthday']=ga.birthday;
          element['id']=ga.id;
          @winfo << element;
          logger.info(ga.amount);
      end

      groupedSpecialActions.each do |ga|
        info = @winfo.select{|info| info['id']==ga.id}.first();
        if !info .nil?
          if info['detail'].nil? 
            info['amount'] = info['amount']-ga.amount;
          end
        else
          element = Hash.new;
          element['amount']=-ga.amount;
          element['fname']=ga.fname;
          element['sname']=ga.sname;
          element['tname']=ga.tname;
          element['birthday']=ga.birthday;
          element['id']=ga.id;
          @winfo << element;
        end    
      end 
  end  

  def showstat1
      @sdate = Date.today.beginning_of_month;
      @edate = Date.today.end_of_month;
      getStat1;
  end  

  def getModalWorkerStatData
    sdate = Date.strptime(params['sdate']);
    edate =  Date.strptime(params['edate']);
    worker_id = params['worker_id'];
    worker = Worker.find(worker_id);
    @worker_name = worker.fname+' '+worker.sname+' '+worker.tname;
    l = edate-sdate+1;
    logger.info('sdate='+sdate.to_s+' edate='+edate.to_s+' l='+l.to_s)
    @dayinfo = Array.new(l) {Hash.new};
    for i in 0..l-1
      @dayinfo[i]['day']=sdate+i;
    end  

      groupedActions = Action.select('sum(cnt) as cnt, cost, sum(amount) as amount, operations.name, date(actions.created_at)').joins(:operation).
        group('date(actions.created_at)', 'operations.name', 'cost').
        where("worker_id=:worker_id and actions.created_at between :start_date and :end_date and coalesce(special,0)<>1" ,
          {worker_id: worker_id, start_date: sdate, end_date: edate}).order('date(actions.created_at)');
      groupedSpecialActions = Action.select('sum(cnt) as cnt, cost, sum(amount) as amount, operations.name, date(actions.created_at)').joins(:operation).group('date(actions.created_at)', 'operations.name', 'cost').where("linkedworker_id=:worker_id and actions.created_at between :start_date and :end_date and special=1",
          {worker_id: worker_id, start_date: sdate, end_date: edate}).order('date(actions.created_at)');
      groupedActions.each do |ga|
        info = @dayinfo.select{|info| info['day']==ga.date}.first();
        if !info .nil?
          if info['detail'].nil? 
            info['detail'] = Array.new(0)
          end;  
          element = Hash.new;#info['detail'].last;
          element['cnt']=ga.cnt;
          element['cost']=ga.cost;
          element['amount']=ga.amount;
          element['operation_name']=ga.name;
          element['date']=ga.date.to_s;
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
            info['detail'] = Array.new(0)
          end;  
          element = Hash.new;#info['detail'].last;
          element['cnt']=ga.cnt;
          element['cost']=ga.cost;
          element['amount']=ga.amount;
          element['operation_name']=ga.name;
          element['date']=ga.date.to_s;
          if info['amount'].nil? 
            info['amount'] = ga.amount
          else  
            info['amount'] = info['amount']-ga.amount;
          end  
          info['detail'] << element;
        end  
      end

    #end;  

  end  

  def showModalWorkerStat
    getModalWorkerStatData;
    respond_to do |format|
      format.js
    end 
  end  

  def refreshStat1
      @valid = true;
      begin
        @sdate = Date.strptime(params['startdate'][0],'%m/%d/%Y');
        @edate = Date.strptime(params['enddate'][0],'%m/%d/%Y');
      rescue => exception
         @valid=false
      end  
      logger.info('refresh');
      if @valid 
        getStat1;
      end  
      respond_to do |format|
        format.js
      end  
  end

  def getWorkerStatPDF
    getModalWorkerStatData;
    pdf = render_to_string(pdf: "ticket", template: "/report/workerStat.html.erb", encoding: "UTF-8")
    save_path = Rails.root.join('pdfs','filename.pdf')
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    send_file(save_path.to_s, :type => "application/pdf", :disposition => "attachment");
  end  

  def stat1
    @sdate = Date.strptime(params['sdate1'],'%m/%d/%Y') rescue Date.today.beginning_of_month;
    @edate = Date.strptime(params['edate1'],'%m/%d/%Y') rescue Date.today.end_of_month;
    getStat1;
    pdf = render_to_string(pdf: "ticket", template: "/report/stat1.html.erb", encoding: "UTF-8")
    save_path = Rails.root.join('pdfs','filename.pdf')
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    send_file(save_path.to_s, :type => "application/pdf", :disposition => "attachment");
  end  
  
#  def to_csv(options = {})
#    CSV.generate(options) do |csv|
#      csv << ["Дата", "Название операции", "Цех", "Сотрудник", "Количество"]
#         @groupedActions.each do |gAction|
#           csv << [gAction[0][0], gAction[0][2], gAction[0][5], "Петров",gAction[1]]
#         end
#    end
#  end

end