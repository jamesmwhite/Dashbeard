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
	  		allSymbols = ""
	  		numStocks = 0
	  		begin
	  			stocks = StockSetting.all.limit(5)
		  		for stock in stocks
		  			if allSymbols.blank?
		  				allSymbols = stock.symbol
		  			else
		  				allSymbols = "#{allSymbols},#{stock.symbol}"
		  			end
		  			numStocks = numStocks + 1
		  			
		  		end
	  		rescue Exception => e
	  			puts "Problem getting stocks from db"
	  		end
	  		
	  		
	  		if allSymbols.blank?
	  			allSymbols = "feye"
	  			numStocks = 1
	  		end
			url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%22#{allSymbols}%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

			begin
				response = Net::HTTP.get(URI.parse(url))
			rescue Exception => e
				puts e.backtrace.join("\n")
			end

			begin
				parsed = JSON.parse(response)
				htmlresp = "<div id=\"stock\">"
				if numStocks > 1
					results = parsed["query"]["results"]["quote"]
					for result in results
						cursymbol = result["symbol"]
						curprice = result["LastTradePriceOnly"]
						change = result["Change"]	
						if change.include? "-"
							change = "<font class=\"stockred\">(#{change})</font>"
						else
							change = "<font class=\"stockgreen\">(#{change})</font>"
						end
						htmlresp = "#{htmlresp} <div id=\"stock-line\"><span id=\"stock-symbol\">#{cursymbol.upcase}</span> <span id=\"stock-price\">#{curprice}</span> <span id=\"stock-change\">#{change}</span></div>"
					end
					htmlresp = "#{htmlresp}</div>
				else
					cursymbol = parsed["query"]["results"]["quote"]["symbol"]
					curprice = parsed["query"]["results"]["quote"]["LastTradePriceOnly"]
					change = parsed["query"]["results"]["quote"]["LastTradePriceOnly"]
					if change.include? "-"
						change = "<font class=\"stockred\">(#{change})</font>"
					else
						change = "<font class=\"stockgreen\">(#{change})</font>"
					end
					htmlresp = "#{htmlresp} #{cursymbol.upcase} #{curprice} #{change}</br>"
				end
				htmlresp = "#{htmlresp} </div></br>"

				DataCache.first
				cache.stock = htmlresp
				cache.stockDate = DateTime.now
				cache.save
				puts "[Stock Data Cached]"
			rescue Exception => ee
				puts ee.backtrace.join("\n")
			end

		
			
		end
			
	 	render :text => htmlresp
		
	end
end
