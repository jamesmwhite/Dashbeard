class BusController < ApplicationController
	respond_to :html
	layout false

	def station
		require 'net/http'
		require "json"


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
			htmlresp = "<h2>Busaras Depatures</h2><table><tr class=\"busheader\"><td>Destination</td><td>Planned Time</td><td>Actual Dept Time</td></tr>"
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
	 	render :json => htmlresp
		
	end
end
