json.array!(@workers) do |worker|
  json.extract! worker, :id, :fname, :sname, :tname, :birthday, :pin
  json.url worker_url(worker, format: :json)
end
