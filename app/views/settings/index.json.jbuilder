json.array!(@settings) do |setting|
  json.extract! setting, :id, :rssfeed, :stocksymbol, :weathercode, :trainstation, :busstopcode, :refreshtime
  json.url setting_url(setting, format: :json)
end
