require 'test_helper'

class DoorLogsControllerTest < ActionController::TestCase
  setup do
    @door_log = door_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:door_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create door_log" do
    assert_difference('DoorLog.count') do
      post :create, :door_log => { :data => @door_log.data, :key => @door_log.key }
    end

    assert_redirected_to door_log_path(assigns(:door_log))
  end

  test "should show door_log" do
    get :show, :id => @door_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @door_log
    assert_response :success
  end

  test "should update door_log" do
    put :update, :id => @door_log, :door_log => { :data => @door_log.data, :key => @door_log.key }
    assert_redirected_to door_log_path(assigns(:door_log))
  end

  test "should destroy door_log" do
    assert_difference('DoorLog.count', -1) do
      delete :destroy, :id => @door_log
    end

    assert_redirected_to door_logs_path
  end
end
