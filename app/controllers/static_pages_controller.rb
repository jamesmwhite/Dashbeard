class StaticPagesController < ApplicationController
	
	respond_to :html
	# layout false

  def home
  end

  def setMessage
    Rails.cache.write("bigMessage", params[:message])
    Rails.cache.write("bigImage", "")
    Rails.cache.write("refreshDate", DateTime.now)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  def setImg
    Rails.cache.write("bigImage", params[:img])
    Rails.cache.write("bigMessage", "")
    Rails.cache.write("refreshDate", DateTime.now)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end


  def checkRefresh
  	render :text => Rails.cache.read("refreshDate")
  end

  def forceRefresh
    Rails.cache.write("refreshDate", DateTime.now)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end
end
