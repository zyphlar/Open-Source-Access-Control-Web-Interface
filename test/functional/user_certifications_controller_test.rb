require 'test_helper'

class UserCertificationsControllerTest < ActionController::TestCase
  setup do
    @user_certification = user_certifications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_certifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_certification" do
    assert_difference('UserCertification.count') do
      post :create, :user_certification => { :certification_id => @user_certification.certification_id, :user_id => @user_certification.user_id }
    end

    assert_redirected_to user_certification_path(assigns(:user_certification))
  end

  test "should show user_certification" do
    get :show, :id => @user_certification
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user_certification
    assert_response :success
  end

  test "should update user_certification" do
    put :update, :id => @user_certification, :user_certification => { :certification_id => @user_certification.certification_id, :user_id => @user_certification.user_id }
    assert_redirected_to user_certification_path(assigns(:user_certification))
  end

  test "should destroy user_certification" do
    assert_difference('UserCertification.count', -1) do
      delete :destroy, :id => @user_certification
    end

    assert_redirected_to user_certifications_path
  end
end
