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
			url = "http://www.buseireann.ie/inc/proto/stopPassageTdi.php?stop_point=6350786630982438745"
			begin
				htmlresp = ""
				uri = URI.parse("http://whensmybus.buseireann.ie")
				http = Net::HTTP.new(uri.host, uri.port)
				http.use_ssl = false
				response = Net::HTTP.get(URI.parse(url))	
				# puts response
				parsed = JSON.parse(response)
				bussArr = Array.new 
				for p in parsed['stopPassageTdi']
					for a in p
						# puts a
						# puts "status: #{a['status']}"
						begin
							if a['departure_data'] and a['status'] #and a['status']!=4
								item = a['departure_data'] 
								actualtime =  item['actual_passage_time_utc']
								scheduleTime = item['scheduled_passage_time_utc']
								destination = item['multilingual_direction_text']['defaultValue']
								begin
									if actualtime
										epoch = actualtime# Time.at(actualtime).strftime("%H:%M")
									else
										epoch = scheduleTime# Time.at(scheduleTime).strftime("%H:%M")
									end
								rescue Exception => e
									puts e.backtrace
								end
								traintext = "#{epoch}: to #{destination}"
								bussArr.push traintext 
							end
						rescue Exception => e
							# puts p
							# puts e.backtrace
						end

					end
				end
				busComArr = Array.new
				htmlresp = "<h2>Busaras Departures</h2>"
				for bus in bussArr.sort
					splitbus = bus.split(': to')
					deptTime = Time.at(splitbus[0].to_i).strftime("%H:%M")
					if deptTime > Time.now
						puts "#{deptTime}:#{splitbus[1]}"
						busComArr.push "<div class=\"train-time-line\"><div class=\"train-departing\">#{deptTime}:#{splitbus[1]}</div></div>"
						htmlresp = "#{htmlresp} <div class=\"train-time-line\"><div class=\"train-departing\">Departing: <span class=\"livetime\">#{deptTime}</span></div><div class=\"journey-time\">#{splitbus[1]}</div></div>"
					end
				end
				htmlresp = "#{htmlresp} </br>"

			rescue Exception => e
				puts e
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
