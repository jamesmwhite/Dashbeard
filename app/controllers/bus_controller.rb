class BusController < ApplicationController
	respond_to :html
	layout false

	def station
		require 'net/http'
		require "json"

		htmlresp = "Data not found"

		goLive = false

		begin
	  		cache = DataCache.first
	  		if cache.blank?
	  			cache = DataCache.new
	  			cache.save
	  			goLive = true
	  		else
		  		lastUpdate = cache.busDate 
				minsSinceUpdate = ((DateTime.now - lastUpdate.to_datetime) * 24 * 60).to_i
				if minsSinceUpdate > 5
					puts "[Bus Cache is over 5 mins old, refreshing]"
					goLive = true
				end
		  		htmlresp = cache.bus
		  		puts "[Bus Cache Loaded]"
		  	end
	  	rescue Exception => e
	  		puts "[Error occurred: Fetching Live Bus]"
	  		goLive = true
	  		# puts e.backtrace.join("\n")
	  	end

	  	if goLive
			url = "http://whensmybus.buseireann.ie/internetservice/services/passageInfo/stopPassages/stop"
			begin
				htmlresp = ""
				uri = URI.parse("http://whensmybus.buseireann.ie")
				http = Net::HTTP.new(uri.host, uri.port)
				http.use_ssl = false
				request = Net::HTTP::Post.new("/internetservice/services/passageInfo/stopPassages/stop")

				stopNum = 13500 # busaras default			
				begin
					setting = Setting.take
					if not setting.busstopcode.empty?
						stopNum = setting.busstopcode
					end
				rescue Exception => ee
					puts ee
				end

				request.body = "stop=#{stopNum}&mode=departure"
				response = http.request(request)
				parsed = JSON.parse(response.body)

				actuals = parsed["actual"]
				htmlresp = "<h2>Busaras Departures</h2><table><tr class=\"busheader\"><td>Destination</td><td>Planned Time</td><td>Actual Dept Time</td></tr>"
				for item in actuals
					htmlresp = "#{htmlresp} <tr><td  class=\"busText\">#{item["direction"]}</td><td class=\"busText\" align=\"center\">#{item["plannedTime"]}</td><td align=\"center\"><font class=\"livetime\">#{item["actualTime"]}</font></td></tr>"
				end
				htmlresp = "#{htmlresp} </table>"

			rescue Exception => e
				puts e
			end

			if htmlresp.empty?
				htmlresp = "No data available, retrying..."
			end
			DataCache.first
			cache.bus = htmlresp
			cache.busDate = DateTime.now
			cache.save
			puts "[Bus Data Cached]"
		end
	 	render :json => htmlresp
		
	end
end
