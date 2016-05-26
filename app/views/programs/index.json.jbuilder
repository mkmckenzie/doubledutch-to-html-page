json.array!(@programs) do |program|
  json.extract! program, :id, :name, :created_at
  json.url program_url(program, format: :json)
end
