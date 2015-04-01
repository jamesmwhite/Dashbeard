require 'test_helper'

class StockSettingsControllerTest < ActionController::TestCase
  setup do
    @stock_setting = stock_settings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_setting" do
    assert_difference('StockSetting.count') do
      post :create, stock_setting: { symbol: @stock_setting.symbol }
    end

    assert_redirected_to stock_setting_path(assigns(:stock_setting))
  end

  test "should show stock_setting" do
    get :show, id: @stock_setting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stock_setting
    assert_response :success
  end

  test "should update stock_setting" do
    patch :update, id: @stock_setting, stock_setting: { symbol: @stock_setting.symbol }
    assert_redirected_to stock_setting_path(assigns(:stock_setting))
  end

  test "should destroy stock_setting" do
    assert_difference('StockSetting.count', -1) do
      delete :destroy, id: @stock_setting
    end

    assert_redirected_to stock_settings_path
  end
end
