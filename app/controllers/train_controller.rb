class TrainController < ApplicationController

	respond_to :html
	layout false

	def station
		require 'net/http'
		responseres = "Data not found"

		goLive = false

		begin
	  		cache = DataCache.first
	  		if cache.blank?
	  			cache = DataCache.new
	  			cache.save
	  			goLive = true
	  		else
		  		lastUpdate = cache.trainDate 
				minsSinceUpdate = ((DateTime.now - lastUpdate.to_datetime) * 24 * 60).to_i
				if minsSinceUpdate > 5
					puts "[Train Cache is over 5 mins old, refreshing]"
					goLive = true
				end
		  		responseres = cache.train
		  		puts "[Train Cache Loaded]"
		  	end
	  	rescue Exception => e
	  		puts "[Error occurred: Fetching Live Train]"
	  		goLive = true
	  		# puts e.backtrace.join("\n")
	  	end

	  	if goLive
			trainCode = 'TARA' # Tara street station default
			# Pulling train station code from settings
			begin
				setting = Setting.take
				if not setting.trainstation.empty?
					trainCode = setting.trainstation
				end
			rescue Exception => ee
				puts ee
			end

			url = "http://www.irishrail.ie/realtime/station-updates.jsp?code=#{trainCode}"
			begin
				result = Net::HTTP.get(URI.parse(url))	
			rescue Exception => e
				puts e
			end
			stationname = "Tara Street"
			# removing images, cos it throws errors on my console, boo
			result = result.gsub(/<img src.+?>/m, '')
			responseres = "<h2> #{stationname} departures</h2>"

			trainsArr = Array.new 

			regresults = result.scan(/((Train|arrow|dart|icr).+?\/tbody>)/mi)
			# puts regresults
			count = 0
			for full in regresults
				if count >50 #put a high number here to not skip anymore, leaving code until certain
					break
				end
				singletrain = full[0].scan(/((Train|arrow|dart|icr).+?td>)/mi)[0]
				if not singletrain.empty?
					singletrain = singletrain[0].gsub(/(\b.+) Service /mi, '')
					singletrain = singletrain.gsub(/">.*/m, '') #At this stage we have the train route
					# puts singletrain 
					stationDeptTime = full[0].scan(/Tara Street.+?tr>/m)
					if not stationDeptTime.empty?
						stationDeptTime = stationDeptTime[0].sub(/.+?time">/m, '')
						stationDeptTime = stationDeptTime.sub(/.+?time">/m, '')
						journeyWithoutTime = singletrain.sub(/[0-9][0-9]:[0-9][0-9] - /, '')
						stationDeptTime = stationDeptTime.sub(/<\/td>.+/m, '') #this is the departure time of the train from tara street
						trainsArr.push "Departing: <font class=\"livetime\">#{stationDeptTime}</font> - #{journeyWithoutTime}</br><br>"
						# responseres = "#{responseres} #{singletrain} departing at <font class=\"livetime\">#{stationDeptTime}</font></br><br>" 
						count = count + 1
					end
				end 
			end

			for train in trainsArr.sort # sorting so trains in order of departure
				responseres = "#{responseres} #{train}"
			end

			
			if responseres.empty?
				responseres = "No data available, retrying..."
			end
			DataCache.first
			cache.train = responseres
			cache.trainDate = DateTime.now
			cache.save
			puts "[Train Data Cached]"
		end

	 	render :text => responseres
		
	end
end
