class PhotoLinksController < ApplicationController
  before_action :set_photo_link, only: [:show, :edit, :update, :destroy]

  respond_to :html
  layout false

  # GET /photo_links
  # GET /photo_links.json
  def index
    @photo_links = PhotoLink.order("created_at DESC")
  end

  # GET /photo_links/1
  # GET /photo_links/1.json
  def show
  end

  # GET /photo_links/new
  def new
    @photo_link = PhotoLink.new
  end

  # GET /photo_links/1/edit
  def edit
  end

  # POST /photo_links
  # POST /photo_links.json
  def create
    @photo_link = PhotoLink.new(photo_link_params)

    respond_to do |format|
      if @photo_link.save
        format.html { redirect_to @photo_link, notice: 'Photo link was successfully created.' }
        format.json { render :show, status: :created, location: @photo_link }
      else
        format.html { render :new }
        format.json { render json: @photo_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photo_links/1
  # PATCH/PUT /photo_links/1.json
  def update
    respond_to do |format|
      if @photo_link.update(photo_link_params)
        format.html { redirect_to @photo_link, notice: 'Photo link was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo_link }
      else
        format.html { render :edit }
        format.json { render json: @photo_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photo_links/1
  # DELETE /photo_links/1.json
  def destroy
    @photo_link.destroy
    respond_to do |format|
      format.html { redirect_to photo_links_url, notice: 'Photo link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def getImages()
    htmlresp = ""
    begin
      # setting limit of 10 here for image rotation, dont want to floor JS on browser
        photos = PhotoLink.where(hidden: false).limit(10)
        photoList = photos.map do |p|
          { :id => p.id, :url => p.url }
        end

        htmlresp = photoList.to_json

    rescue Exception => e
      puts "Problem getting images"
      puts e.backtrace.join("\n")
    end
    render :text => htmlresp
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo_link
      @photo_link = PhotoLink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_link_params
      params.require(:photo_link).permit(:url, :hidden)
    end
end
