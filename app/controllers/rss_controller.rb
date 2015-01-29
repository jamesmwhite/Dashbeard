class RssController < ApplicationController

	respond_to :html
	layout false

	def feed
		require 'rss'
		require 'open-uri'

		url = 'http://threatpost.com/feed'
		htmlresp = ""
		open(url) do |rss|
		  feed = RSS::Parser.parse(rss)
		  htmlresp = "<tr><td width=\"60%\" valign=\"top\" rowspan=\"30\"><div align=\"center\" class=\"rssTitle\">Security News</div><div id=\"rssdiv\">"
		  feed.items.each do |item|
		    htmlresp = "#{htmlresp} <h3 class=\"rssHeader\">#{item.title}</h3> <div class=\"rssDescription\">#{item.description}</br></br></div>"
		  end
		end
		htmlresp = "#{htmlresp}</div></td></tr>"

		render :text => htmlresp
	end
end
