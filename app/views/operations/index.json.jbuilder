json.array!(@operations) do |operation|
  json.extract! operation, :id, :name, :special, :workshop_id
  json.url operation_url(operation, format: :json)
end
