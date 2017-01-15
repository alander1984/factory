class SpravController < ApplicationController
  
  def getWorkerName(barcode)
    qstring="isactive=true and ((+31536000*50+cast(extract(epoch from birthday) as bigint))*1000+id+pin="+barcode+" or cardcode='"+barcode+"')";
    tworker_name='неведомый бродяга, мы не узнали вас в гриме...'
    worklist= Worker.where(qstring);
    if worklist.size>0 
      tworker_name=worklist[0].fname+' '+worklist[0].sname+' '+worklist[0].tname ;
      @worker_id=worklist[0].id;
    end  
    return tworker_name
  end
  
  def chooseOrg
    @barcode_id=params['barcode_input'];
    @pin=params['pin_input'];
    if @pin==nil 
      @pin="id"; #Это вставляем для того, чтобы запрос не падал, если пин не ввели
    end
    @workshops = [];
    qstring="isactive=true and ((+31536000*50+cast(extract(epoch from birthday) as bigint))*1000+id+pin="+@barcode_id+" or cardcode='"+@barcode_id+"')";
    @worker_name='неведомый бродяга, мы не узнали вас в гриме...';
    @worker_found =false;
    begin
      worklist= Worker.where(qstring);
      if worklist.size>0 
        @worker_found = true;
        @worker_name=worklist[0].fname+' '+worklist[0].sname+' '+worklist[0].tname ;
        @worker_id=worklist[0].id;
        @pin=worklist[0].pin;
        @workshops = Workshop.all;
      end  
      rescue Exception => exc
        worklist=[]
      end    
  end
  
  def chooseOperation
    @barcode_id=params['barcode_input'];
    @worker_name=getWorkerName(@barcode_id)
    @workshop_id=params['workshop_id'];
    @operations=Operation.where('workshop_id='+params['workshop_id']+' and isactive=true').all;
    @pin=params['pin_input'];
  end
  
  def createAction
    @pin=params['pin_input'];
    @barcode_id=params['barcode_input'];
    @workshop_id=params['workshop_id'];
    @worker_name=getWorkerName(params['barcode_input'])
    operation_lst=Operation.where('id='+params['operation_id']+' and isactive=true');
    if operation_lst.size==1 
      @operation = operation_lst[0];
      @operation_name=@operation.name;
    end  
    @operation_id=params['operation_id']
  end

  def registerAction
    @pin=params['pin_input'];
    @barcode_id=params['barcode_input'];
    @workshop_id=params['workshop_id'];
    qstring="isactive=true and ((+31536000*50+cast(extract(epoch from birthday) as bigint))*1000+id+pin="+@barcode_id+" or cardcode='"+@barcode_id+"')";
    worker_id=-1;
    worklist= Worker.where(qstring);
    if worklist.size>0 
      worker_id=worklist[0].id;
    end;  
    action = Action.new;
    action.worker_id=worker_id;
    action.operation_id=params['oper_id'];
    action.cnt=params['operation_cnt'];
    action.linkedoperation_id=params['linkedoperation_id'];
    action.linkedworker_id=params['linkedworker_id'];
    #Берем одну запись из стоимостей без всяких алгоритмов
    oc = OperationCost.where('operation_id = '+params['oper_id']+' and current_date >= sdate').order('sdate desc').take(1);
    if oc.size>0
      action.cost=oc[0].cost;
      action.amount=(oc[0].cost*action.cnt).round(2);
    end;  
    action.save;
    redirect_to :action=>'chooseOperation', :workshop_id=>@workshop_id, :barcode_input=>@barcode_id, :pin_input=>@pin;   
    #Автоматически пока ничего не печатаем, если что - раскомментируем строчку
    #redirect_to :action=>'printTicket', :id => action.id ,:workshop_id=>@workshop_id, :barcode_input=>@barcode_id, :pin_input=>@pin;   
  end

  def printTicket
    @pin=params['pin_input'];
    @barcode_id=params['barcode_input'];
    @workshop_id=params['workshop_id'];
    act = params['act'];
    if ['today', 'yesterday', 'thisweek', 'lastweek', 'thismonth', 'lastmonth'].include?(act)  
      @url_print = url_for("http://localhost:3000/print/period/"+params['act']+'?worker_id='+params['worker_id']);  
      @url_redirect = url_for(action: 'chooseOrg', :barcode_input => @barcode_id, :pin_input => @pin);
    else
      @url_print = url_for("http://localhost:3000/print/action/"+params['id']);
      @url_redirect = url_for(action: 'chooseOperation', :workshop_id => @workshop_id, :barcode_input => @barcode_id, :pin_input => @pin);
    end  
  end  

  def chooseLinkedOperation
     @operation = Operation.find(params['operation_id']);
     @avalOps = Operation.joins(:action).where("actions.created_at>=current_date-2
        and coalesce(special,0)<>1
        and workshop_id=:workshop",{workshop: @operation.workshop_id}).distinct; 
     @avalWrks = Worker.joins(:action).joins(:operation).where("actions.created_at>=current_date-2
        and coalesce(special,0)<>1
        and workshop_id=:workshop",{workshop: @operation.workshop_id}).distinct; 
     respond_to do |format|
      format.html
      format.js
    end
  end  
  
  def selectLinkedOper
    @operation = Operation.find(params["operation_id"]);
    respond_to do |format|
      format.js
    end  
  end  

  def selectLinkedWorker
    @worker = Worker.find(params["worker_id"])
    respond_to do |format|
      format.js
    end  

  end  



end