json.extract! @action, :id, :cnt, :created_at, :cost, :amount
json.operation @action.operation, :id,:name if @action.operation!=nil
json.linkedoperation @action.linkedoperation, :id, :name if @action.linkedoperation!=nil
json.worker @action.worker, :id, :fname, :sname, :tname if @action.worker!=nil
json.linkedworker @action.linkedworker, :id, :fname, :sname, :tname if @action.linkedworker!=nil
