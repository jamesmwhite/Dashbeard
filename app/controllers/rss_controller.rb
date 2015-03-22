class RssController < ApplicationController

	respond_to :html
	layout false

	def feed
		require 'rss'
		require 'open-uri'

		htmlresp = "Data not found"

		goLive = false

		begin
	  		cache = DataCache.first
	  		if cache.blank?
	  			cache = DataCache.new
	  			cache.save
	  			goLive = true
	  		else
		  		lastUpdate = cache.rssDate 
				minsSinceUpdate = ((DateTime.now - lastUpdate.to_datetime) * 24 * 60).to_i
				if minsSinceUpdate > 5
					puts "[Rss Cache is over 5 mins old, refreshing]"
					goLive = true
				end
		  		htmlresp = cache.rss
		  		puts "[Rss Cache Loaded]"
		  	end
	  	rescue Exception => e
	  		puts "[Error occurred: Fetching Live Rss]"
	  		goLive = true
	  		# puts e.backtrace.join("\n")
	  	end

	  	if goLive

			rssUrl = "http://threatpost.com/feed" # Default value for RSS
			# Pulling rss URL from settings
			begin
				setting = Setting.take
				if not setting.rssfeed.empty?
					rssUrl = setting.rssfeed
				end
			rescue Exception => ee
				puts ee
			end

			begin
				htmlresp = ""
				open(rssUrl) do |rss|
				  feed = RSS::Parser.parse(rss)
				  htmlresp = "<td id=\"rss\" width=\"60%\" valign=\"top\" rowspan=\"30\"><div align=\"center\" class=\"rssTitle\">Security News</div><div>"
				  feed.items.each do |item|
				    htmlresp = "#{htmlresp} <h3 class=\"rssHeader\">#{item.title}</h3> <div class=\"infoSurround\">#{item.description} </br></br></div>"
				  end
				end
				htmlresp = "#{htmlresp}</div></td>"
			rescue Exception => ee
				htmlresp = "<td id=\"rss\" width=\"60%\" valign=\"top\" rowspan=\"30\"><div align=\"center\" class=\"rssTitle\">Security News</div><div class=\"jimmy marquee\" id=\"rssdiv\"><span>"
				htmlresp = "#{htmlresp} No data found"
				htmlresp = "#{htmlresp}</span></div></td>"
			end
			DataCache.first
			cache.rss = htmlresp
			cache.rssDate = DateTime.now
			cache.save
			puts "[Rss Data Cached]"
		end

		render :text => htmlresp
	end
end
