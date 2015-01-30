class StockController < ApplicationController

	respond_to :html
	layout false

	def quote
		require 'net/http'
		url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%22FEYE%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
		begin
			result = Net::HTTP.get(URI.parse(url))	
			puts result
		rescue Exception => e
			puts e
		end

		parsed = JSON.parse(result)
		curprice = parsed["query"]["results"]["quote"]["LastTradePriceOnly"]
		change = parsed["query"]["results"]["quote"]["Change"]
		if change.include? "-"
			change = "<font class=\"stockred\">(#{change})</font>"
		else
			change = "<font class=\"stockgreen\">(#{change})</font>"
		end
		htmlresp = "<div class=\"stock\"> FEYE #{curprice} #{change}</div></br></br>"
		if htmlresp.empty?
			htmlresp = "No data available, retrying..."
		end
		
	 	render :text => htmlresp
		
	end
end
