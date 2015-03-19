json.array!(@data_caches) do |data_cach|
  json.extract! data_cach, :id, :stock, :rss, :bus, :train
  json.url data_cach_url(data_cach, format: :json)
end
