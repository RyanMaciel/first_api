require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @user = User.new(username: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar");
    @post = Post.new(image_url: "test.test.com/image.jpg", latitude: 1.2345, longitude: 1.2345)
    @post.user = @user
    @post.save
    
    @user.generate_api_key
    @user.save
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should create post" do
    

    assert_difference('Post.count') do
      post :create, post: { image_url: @post.image_url, latitude: @post.latitude, longitude: @post.longitude}, user_id: @user.id, user_api_key: @user.api_key
    end

    assert_response :success
  end

  test "should show post" do
    #the post must be save or the controller wont have any posts to show.
    @post.save
    get :show, id: @post.id
    assert_response :success
  end

#needs to be fixed
  test "should update post" do
    @post.save
    put :update, id: @post.id, post: { image_url: @post.image_url, latitude: @post.latitude, longitude: @post.longitude }, user_id: @user.id, user_api_key: @user.api_key
    assert_response :no_content
  end

  test "should destroy post" do
    @post.save
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post.id, user_id: @user.id, user_api_key: @user.api_key
    end

    assert_response :no_content
  end
end
