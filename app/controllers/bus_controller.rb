class BusController < ApplicationController
	respond_to :html
	layout false

	def station
		require 'net/http'
		require "json"


		url = "http://whensmybus.buseireann.ie/internetservice/services/passageInfo/stopPassages/stop"
		begin
			uri = URI.parse("http://whensmybus.buseireann.ie")
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = false
			request = Net::HTTP::Post.new("/internetservice/services/passageInfo/stopPassages/stop")
			request.body = 'stop=13500&mode=departure'
			response = http.request(request)
			parsed = JSON.parse(response.body)
			# puts response.body
			# puts parsed.class
			actuals = parsed["actual"]
			htmlresp = "<table><tr><td>Destination</td><td>Planned Time</td><td>Actual Dept Time</td></tr>"
			for item in actuals
				htmlresp = "#{htmlresp} <tr><td>#{item["direction"]}</td><td align=\"center\">#{item["plannedTime"]}</td><td align=\"center\"><font color=\"red\">#{item["actualTime"]}</font></td></tr>"
			end
			htmlresp = "#{htmlresp} </table>"
			# puts htmlresp


		rescue Exception => e
			puts e
		end

		
	 	render :json => htmlresp
		
	end
end
