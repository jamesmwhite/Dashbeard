class StaticPagesController < ApplicationController
	
	respond_to :html
	# layout false

  def home
  end

  def setMessage
    Rails.cache.write("bigMessage", params[:message])
    if params[:message].blank?
    	Rails.cache.write("mode", "")
    else
    	Rails.cache.write("mode", "message")
    end
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  def setImg
    Rails.cache.write("bigImage", params[:img])
    if params[:img].blank?
    	Rails.cache.write("mode", "")
    else
    	Rails.cache.write("mode", "img")
    end
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end


  def checkRefresh
  	render :text => Rails.cache.read("mode")
  end
end
