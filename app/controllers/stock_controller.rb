class StockController < ApplicationController

	respond_to :html
	layout false

	def quote
		require 'net/http'
		htmlresp = "No data available, retrying..."

		stockSymbol = "feye" # default stock symbol
		# Pulling stock symbol from settings
		begin
			setting = Setting.find(1)
			stockSymbol = setting.stockSymbol
		rescue Exception => ee
			puts ee
		end
		#hardcoding second symbol now until I update settings to cater for more than one symbol
		stockSymbol2 = "panw"
		url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%22#{stockSymbol}%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
		url2 = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%22#{stockSymbol2}%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
		begin
			result = Net::HTTP.get(URI.parse(url))	
			result2 = Net::HTTP.get(URI.parse(url2))	
			# puts result
		rescue Exception => e
			puts e
		end

		begin
			parsed = JSON.parse(result)
			curprice = parsed["query"]["results"]["quote"]["LastTradePriceOnly"]
			change = parsed["query"]["results"]["quote"]["Change"]
			# puts change
			if change.include? "-"
				change = "<font class=\"stockred\">(#{change})</font>"
			else
				change = "<font class=\"stockgreen\">(#{change})</font>"
			end
			# htmlresp = "<div class=\"stock\"> FEYE #{curprice} #{change}</div></br>"

			parsed2 = JSON.parse(result2)
			curprice2 = parsed2["query"]["results"]["quote"]["LastTradePriceOnly"]
			change2 = parsed2["query"]["results"]["quote"]["Change"]
			# puts change
			if change2.include? "-"
				change2 = "<font class=\"stockred\">(#{change})</font>"
			else
				change2 = "<font class=\"stockgreen\">(#{change})</font>"
			end
			htmlresp = "<div class=\"stock\"> #{stockSymbol} #{curprice} #{change}  #{stockSymbol2} #{curprice2} #{change2} </div></br>"
			
		rescue Exception => ee
			puts ee
		end

		
	 	render :text => htmlresp
		
	end
end
