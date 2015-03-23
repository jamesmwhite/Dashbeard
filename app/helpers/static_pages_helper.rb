module StaticPagesHelper
	def getMarquee()
		begin
			return Setting.first.marquee
		rescue Exception => e
			puts "No marquee set"
		end
	end

	def getBigMessage()
		begin
			msg = Rails.cache.read("bigMessage")
			if not msg.blank?
				session[:mode] = "message"
			else
				session[:mode] = ""
			end
			return msg
		rescue Exception => e
			puts "No big message"
		end
	end

	def getBigImage()
		begin
			img = Rails.cache.read("bigImage")
			if not img.blank?
				session[:mode] = "img"
			else
				session[:mode] = ""
			end
			return img
		rescue Exception => e
			puts "No big message"
		end
	end
end
