class StockSettingsController < ApplicationController
  before_action :set_stock_setting, only: [:show, :edit, :update, :destroy]

  # GET /stock_settings
  # GET /stock_settings.json
  def index
    @stock_settings = StockSetting.all
  end

  # GET /stock_settings/1
  # GET /stock_settings/1.json
  def show
  end

  # GET /stock_settings/new
  def new
    @stock_setting = StockSetting.new
  end

  # GET /stock_settings/1/edit
  def edit
  end

  # POST /stock_settings
  # POST /stock_settings.json
  def create
    @stock_setting = StockSetting.new(stock_setting_params)

    respond_to do |format|
      if @stock_setting.save
        format.html { redirect_to @stock_setting, notice: 'Stock setting was successfully created.' }
        format.json { render :show, status: :created, location: @stock_setting }
      else
        format.html { render :new }
        format.json { render json: @stock_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stock_settings/1
  # PATCH/PUT /stock_settings/1.json
  def update
    respond_to do |format|
      if @stock_setting.update(stock_setting_params)
        format.html { redirect_to @stock_setting, notice: 'Stock setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock_setting }
      else
        format.html { render :edit }
        format.json { render json: @stock_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_settings/1
  # DELETE /stock_settings/1.json
  def destroy
    @stock_setting.destroy
    respond_to do |format|
      format.html { redirect_to stock_settings_url, notice: 'Stock setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_setting
      @stock_setting = StockSetting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_setting_params
      params.require(:stock_setting).permit(:symbol)
    end
end
