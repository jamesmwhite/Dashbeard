require 'test_helper'

class DataCachesControllerTest < ActionController::TestCase
  setup do
    @data_cach = data_caches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:data_caches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create data_cach" do
    assert_difference('DataCache.count') do
      post :create, data_cach: { bus: @data_cach.bus, rss: @data_cach.rss, stock: @data_cach.stock, train: @data_cach.train }
    end

    assert_redirected_to data_cach_path(assigns(:data_cach))
  end

  test "should show data_cach" do
    get :show, id: @data_cach
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @data_cach
    assert_response :success
  end

  test "should update data_cach" do
    patch :update, id: @data_cach, data_cach: { bus: @data_cach.bus, rss: @data_cach.rss, stock: @data_cach.stock, train: @data_cach.train }
    assert_redirected_to data_cach_path(assigns(:data_cach))
  end

  test "should destroy data_cach" do
    assert_difference('DataCache.count', -1) do
      delete :destroy, id: @data_cach
    end

    assert_redirected_to data_caches_path
  end
end
