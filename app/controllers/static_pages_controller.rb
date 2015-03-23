class StaticPagesController < ApplicationController
	
	respond_to :html
	# layout false

  def home
  end

  def setMessage
    Rails.cache.write("bigMessage", params[:message])
    Rails.cache.write("mode", "message")
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  def setImg
    Rails.cache.write("bigImage", params[:img])
    Rails.cache.write("mode", "img")
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end


  def checkRefresh
  	puts session[:mode]

	if not defined? session[:mode] or session[:mode].blank?
		if not Rails.cache.read("mode").blank?
			puts "Refresh needed"
			puts "Rails cache: #{Rails.cache.read("mode")}"
			puts "Session mode: #{session[:mode]}"
			render :text => "yes"	
		else
			puts "No Refresh needed"
			puts "Rails cache: #{Rails.cache.read("mode")}"
			puts "Session mode: #{session[:mode]}"
			render :text => "no"
		end
		
	else
		if session[:mode] == Rails.cache.read("mode")
			puts "No Refresh needed"
			puts "Rails cache: #{Rails.cache.read("mode")}"
			puts "Session mode: #{session[:mode]}"
			render :text => "no"
		else
			puts "Refresh needed"
			puts "Rails cache: #{Rails.cache.read("mode")}"
			puts "Session mode: #{session[:mode]}"
			render :text => "yes"
		end

	end

  end
end
