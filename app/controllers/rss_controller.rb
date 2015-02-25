class RssController < ApplicationController

	respond_to :html
	layout false

	def feed
		require 'rss'
		require 'open-uri'

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
			  htmlresp = "<tr><td id=\"rss\" width=\"60%\" valign=\"top\" rowspan=\"30\"><div align=\"center\" class=\"rssTitle\">Security News</div><div class=\"jimmy marquee\" id=\"rssdiv\"><span>"
			  feed.items.each do |item|
			    htmlresp = "#{htmlresp} <h3 class=\"rssHeader\">#{item.title}</h3> <div class=\"infoSurround\">#{item.description}</br></br></div>"
			  end
			end
			htmlresp = "#{htmlresp}</span></div></td></tr>"
		rescue Exception => ee
			htmlresp = "<tr><td id=\"rss\" width=\"60%\" valign=\"top\" rowspan=\"30\"><div align=\"center\" class=\"rssTitle\">Security News</div><div class=\"jimmy marquee\" id=\"rssdiv\"><span>"
			htmlresp = "#{htmlresp} No data found"
			htmlresp = "#{htmlresp}</span></div></td></tr>"
		end

		render :text => htmlresp
	end
end
