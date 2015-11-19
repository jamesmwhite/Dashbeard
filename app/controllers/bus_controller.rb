class BusController < ApplicationController
	respond_to :html
	layout false

	def station
		require 'net/http'
		require "json"
		require 'date'

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
	  	goLive = true
	  	if goLive

			oldurl = "http://whensmybus.buseireann.ie/internetservice/services/passageInfo/stopPassages/stop"
			url = "http://www.buseireann.ie/inc/proto/stopPassageTdi.php?stop_point=6350786630982438745"
			begin
				htmlresp = ""
				uri = URI.parse("http://whensmybus.buseireann.ie")
				http = Net::HTTP.new(uri.host, uri.port)
				http.use_ssl = false
				# request = Net::HTTP::Post.new("/internetservice/services/passageInfo/stopPassages/stop")

				# stopNum = 135001 # busaras default			
				# begin
				# 	setting = Setting.take
				# 	if not setting.busstopcode.empty?
				# 		stopNum = setting.busstopcode
				# 	end
				# rescue Exception => ee
				# 	puts ee
				# end

				# request.body = "stop=#{stopNum}&mode=departure"
				# response = http.request(request)
				response = Net::HTTP.get(URI.parse(url))	
				# puts response
				parsed = JSON.parse(response)
				for p in parsed['stopPassageTdi']
					for a in p
						# puts a
						# puts "status: #{a['status']}"
						begin
							if a['departure_data'] and a['status'] and a['status']==1
								item = a['departure_data'] 

								# puts item.class.name
								# item.each_key do |key|
								# 	puts "#{key}" # prints each key.
								# end
								actualtime =  item['actual_passage_time_utc']
								destination = item['multilingual_direction_text']['defaultValue']
								scheduleTime = item['scheduled_passage_time_utc']
								# puts destination
								begin
									if actualtime
										humanTime =  Time.at(actualtime).strftime("%H:%M")
									else
										humanTime =  Time.at(scheduleTime).strftime("%H:%M")
									end
								rescue Exception => e
									puts e.backtrace
								end
								puts "#{destination} will depart at #{humanTime} with status #{a['status']}"
								# puts "#{destination} will depart at "
								


								# puts bla.class.name
								# puts bla['actual_passage_time_utc']
							end
						rescue Exception => e
							# puts p
							# puts e.backtrace
						end

					end
				end


				# htmlresp = "<h2>Busaras Departures</h2>"
    #     htmlresp = "#{htmlresp}<h3 class=\"bus-time-line\"><span class=\"bus-departing\">Destination</span><span class=\"bus-planned\">Planned Time</span><span>Actual Time</span></h3>"
				# for item in actuals
    #       actualItem = "<span>&nbsp</span>"
    #       unless item["actualTime"].nil?
    #         actualItem = "<span class=\"livetime\">#{item["actualTime"]}</span>"
    #       end
				# 	htmlresp = "#{htmlresp} <div class=\"bus-time-line\"><span class=\"bus-departing\">#{item["direction"]}</span><span class=\"bus-planned\">#{item["plannedTime"]}</span>#{actualItem}</div>"
				# end

			rescue Exception => e
				puts e.backtrace
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
