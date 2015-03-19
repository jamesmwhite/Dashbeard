class DataCachesController < ApplicationController
  before_action :set_data_cach, only: [:show, :edit, :update, :destroy]

  # GET /data_caches
  # GET /data_caches.json
  def index
    @data_caches = DataCache.all
  end

  # GET /data_caches/1
  # GET /data_caches/1.json
  def show
  end

  def clearAll
    DataCache.delete_all
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Data cache blown away.' }
    end
  end

  # GET /data_caches/new
  def new
    @data_cach = DataCache.new
  end

  # GET /data_caches/1/edit
  def edit
  end

  # POST /data_caches
  # POST /data_caches.json
  def create
    @data_cach = DataCache.new(data_cach_params)

    respond_to do |format|
      if @data_cach.save
        format.html { redirect_to @data_cach, notice: 'Data cache was successfully created.' }
        format.json { render :show, status: :created, location: @data_cach }
      else
        format.html { render :new }
        format.json { render json: @data_cach.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_caches/1
  # PATCH/PUT /data_caches/1.json
  def update
    respond_to do |format|
      if @data_cach.update(data_cach_params)
        format.html { redirect_to @data_cach, notice: 'Data cache was successfully updated.' }
        format.json { render :show, status: :ok, location: @data_cach }
      else
        format.html { render :edit }
        format.json { render json: @data_cach.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_caches/1
  # DELETE /data_caches/1.json
  def destroy
    @data_cach.destroy
    respond_to do |format|
      format.html { redirect_to data_caches_url, notice: 'Data cache was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_cach
      @data_cach = DataCache.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_cach_params
      params.require(:data_cach).permit(:stock, :rss, :bus, :train)
    end
end
