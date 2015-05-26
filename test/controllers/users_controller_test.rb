require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = User.new(username: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar");
    @user.generate_api_key
    @user.save
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {username: "test", email: "test@test.com", password: "foobar", password_confirmation: "foobar"}
    end

    assert_response 201
  end

  test "should show user" do
    get :show, id: @user.id
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user.id, user: {username: "test", email: "test@test.com", password: "foobar", password_confirmation: "foobar"}, user_api_key: @user.api_key
    assert_response :no_content
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.id
    end

    assert_response :no_content
  end

  test "should authenticate user" do
    
    post :get_api_key, user: {username: "test1234", email: "test@test.com", password: "foobar", password_confirmation: "foobar"}
    
    assert_response 200

  end
end
