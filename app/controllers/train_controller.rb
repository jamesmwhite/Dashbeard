class TrainController < ApplicationController

	respond_to :html
	layout false

	def station
		require 'net/http'
		url = "http://www.irishrail.ie/realtime/station-updates.jsp?code=TARA"
		begin
			result = Net::HTTP.get(URI.parse(url))	
		rescue Exception => e
			puts e
		end
		stationname = "Tara Street"
		# removing images, cos it throws errors on my console, boo
		result = result.gsub(/<img src.+?>/m, '')
		responseres = ""

		regresults = result.scan(/((Train|arrow|dart|icr).+?\/tbody>)/mi)
		puts regresults
		for full in regresults
			singletrain = full[0].scan(/((Train|arrow|dart|icr).+?td>)/mi)[0]
			if not singletrain.empty?
				singletrain = singletrain[0].gsub(/(\b.+) Service /mi, '')
				singletrain = singletrain.gsub(/">.*/m, '') #At this stage we have the train route
				# puts singletrain 
				stationDeptTime = full[0].scan(/Tara Street.+?tr>/m)
				if not stationDeptTime.empty?
					stationDeptTime = stationDeptTime[0].sub(/.+?time">/m, '')
					stationDeptTime = stationDeptTime.sub(/.+?time">/m, '')
					stationDeptTime = stationDeptTime.sub(/<\/td>.+/m, '') #this is the departure time of the train from tara street
					responseres = "#{responseres} #{singletrain} departing at <font class=\"livetime\">#{stationDeptTime}</font></br><br>" 
				end
			end 
		end
		
		if responseres.empty?
			responseres = "No data available, retrying..."
		end
	 	render :text => responseres
		
	end
end
