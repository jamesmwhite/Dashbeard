module StaticPagesHelper
	def getMarquee()
		begin
			return Setting.first.marquee
		rescue Exception => e
			puts "No marquee set"
		end
	end
end
