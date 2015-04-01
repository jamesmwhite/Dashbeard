json.array!(@stock_settings) do |stock_setting|
  json.extract! stock_setting, :id, :symbol
  json.url stock_setting_url(stock_setting, format: :json)
end
