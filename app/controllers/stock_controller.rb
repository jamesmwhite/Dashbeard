class StockController < ApplicationController

	respond_to :html
	layout false

	def quote
		require 'net/http'
		htmlresp = "No data available, retrying..."
		goLive = false

	  	begin
	  		cache = DataCache.first
	  		if cache.blank?
	  			cache = DataCache.new
	  			cache.save
	  			goLive = true
	  		else
		  		lastUpdate = cache.stockDate 
				minsSinceUpdate = ((DateTime.now - lastUpdate.to_datetime) * 24 * 60).to_i
				if minsSinceUpdate > 10
					puts "[Stock Cache is over 10 mins old, refreshing]"
					goLive = true
				end
		  		htmlresp = cache.stock
		  		puts "[Stock Cache Loaded]"
		  	end
	  	rescue Exception => e
	  		puts "[Error occurred: Fetching Live Stock]"
	  		goLive = true
	  		# puts e.backtrace.join("\n")
	  	end

	  	if goLive
			stockSymbol = "feye" # default stock symbol
			stockSymbol2 = "panw"
			stockSymbol3 = "symc"
			stockSymbol4 = "intc"
			# Pulling stock symbol from settings
			begin
				setting = Setting.first
				if not setting.blank? and defined? setting.stocksymbol
					if not setting.stocksymbol.blank?
						stockSymbol = setting.stocksymbol
					end
				end
			rescue Exception => eee
				puts eee.backtrace.join("\n")
			end
			#hardcoding second symbol now until I update settings to cater for more than one symbol
			
			url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%22#{stockSymbol}%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
			url2 = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%22#{stockSymbol2}%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
			url3 = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%22#{stockSymbol3}%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
			url4 = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%22#{stockSymbol4}%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
			begin
				result = Net::HTTP.get(URI.parse(url))

				result2 = Net::HTTP.get(URI.parse(url2))	

				result3 = Net::HTTP.get(URI.parse(url3))	

				result4 = Net::HTTP.get(URI.parse(url4))	
				# puts result
			rescue Exception => e
				puts e.backtrace.join("\n")
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
			rescue Exception => ee
				puts ee.backtrace.join("\n")
			end

			begin
				parsed2 = JSON.parse(result2)
				curprice2 = parsed2["query"]["results"]["quote"]["LastTradePriceOnly"]
				change2 = parsed2["query"]["results"]["quote"]["Change"]
				# puts change
				if change2.include? "-"
					change2 = "<font class=\"stockred\">(#{change2})</font>"
				else
					change2 = "<font class=\"stockgreen\">(#{change2})</font>"
				end
			rescue Exception => ee
				puts ee.backtrace.join("\n")
			end

			begin
				parsed3 = JSON.parse(result3)
				curprice3 = parsed3["query"]["results"]["quote"]["LastTradePriceOnly"]
				change3 = parsed3["query"]["results"]["quote"]["Change"]
				# puts change
				if change3.include? "-"
					change3 = "<font class=\"stockred\">(#{change3})</font>"
				else
					change3 = "<font class=\"stockgreen\">(#{change3})</font>"
				end
			rescue Exception => ee
				puts ee.backtrace.join("\n")
			end

			begin
				parsed4 = JSON.parse(result4)
				curprice4 = parsed4["query"]["results"]["quote"]["LastTradePriceOnly"]
				change4 = parsed4["query"]["results"]["quote"]["Change"]
				# puts change
				if change4.include? "-"
					change4 = "<font class=\"stockred\">(#{change4})</font>"
				else
					change4 = "<font class=\"stockgreen\">(#{change4})</font>"
				end
			rescue Exception => ee
				puts ee.backtrace.join("\n")
			end

			htmlresp = "<div id=\"stock\">
      <div id=\"stock-line\"><span id=\"stock-symbol\">#{stockSymbol.upcase}</span> <span id=\"stock-price\">#{curprice}</span> <span id=\"stock-change\">#{change}</span></div>
			<div id=\"stock-line\"><span id=\"stock-symbol\">#{stockSymbol2.upcase}</span> <span id=\"stock-price\">#{curprice2}</span> <span id=\"stock-change\">#{change2}</span></div>
			<div id=\"stock-line\"><span id=\"stock-symbol\">#{stockSymbol3.upcase}</span> <span id=\"stock-price\">#{curprice3}</span> <span id=\"stock-change\">#{change3}</span></div>
			<div id=\"stock-line\"><span id=\"stock-symbol\">#{stockSymbol4.upcase}</span> <span id=\"stock-price\">#{curprice4}</span> <span id=\"stock-change\">#{change4} </span></div>
			</div>"
			DataCache.first
			cache.stock = htmlresp
			cache.stockDate = DateTime.now
			cache.save
			puts "[Stock Data Cached]"
		end
			
	 	render :text => htmlresp
		
	end
end
