json.rowcnt @eCount
json.wName @worker.fname+' '+@worker.sname+' '+@worker.tname
json.totalAmount @totalAmount
json.data do
	json.array!(@dayinfo)
end	