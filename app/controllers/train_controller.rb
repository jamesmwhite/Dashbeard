class TrainController < ApplicationController

	respond_to :html
	layout false

	def station
		require 'net/http'
		url = "http://www.irishrail.ie/realtime/station-updates.jsp?code=TARA"
		begin
			result = Net::HTTP.get(URI.parse(url))	
			# result = File.read("/Users/jimmy/testdata.html")
		rescue Exception => e
			
		end
		stationname = "Tara Street"
		# removing images, cos it throws errors on my console, boo
		result = result.gsub(/<img src.+?>/m, '')
		responseres = ""

		regresults = result.scan(/(Train.+?\/tbody>)/m)
		for full in regresults
			singletrain = full[0].scan(/(Train.+?td>)/m)[0]
			if not singletrain.empty?
				singletrain = singletrain[0].gsub(/Train Service /m, '')
				singletrain = singletrain.gsub(/">.*/m, '') #At this stage we have the train route
				# puts singletrain 
				stationDeptTime = full[0].scan(/Tara Street.+?tr>/m)
				if not stationDeptTime.empty?
					stationDeptTime = stationDeptTime[0].sub(/.+?time">/m, '')
					stationDeptTime = stationDeptTime.sub(/.+?time">/m, '')
					stationDeptTime = stationDeptTime.sub(/<\/td>.+/m, '') #this is the departure time of the train from tara street
					responseres = "#{responseres} <font color=\"blue\">#{singletrain}</font> departing from Tara Street at <font color=\"red\">#{stationDeptTime}</font></br><br>" 
				end
			end 
		end
		
	 	render :text => responseres
		
	end
end
