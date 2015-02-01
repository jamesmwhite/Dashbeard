json.array!(@settings) do |setting|
  json.extract! setting, :id, :rssfeed, :stocksymbol, :weathercode, :trainstationcode, :busstationcode, :refreshfrequency
  json.url setting_url(setting, format: :json)
end
