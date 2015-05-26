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
  
    #Make sure that a new post is created and saved.
    assert_difference('Post.count') do
      post :create, post: { image_url: @post.image_url, latitude: @post.latitude, longitude: @post.longitude}, user_id: @user.id, user_api_key: @user.api_key
    end

    assert_response :success

    #Make sure that the post's user has been set
    assert @post.user == @user
    assert @user.posts.include?(@post)
  end

  test "should show post" do
    #The post must be save or the controller wont have any posts to show.
    @post.save
    get :show, id: @post.id
    assert_response :success
  end


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

  #test likes
  test "should like eligible post" do
    assert_difference('Like.count', 1) do
      post :like, id: @post.id, user_id: @user.id, user_api_key: @user.api_key
    end
    assert_response :no_content
  end

  test "should unlike eligible post" do
    assert_difference('Like.count', -1) do
      post :unlike, id: @post.id, user_id: @user.id, user_api_key: @user.api_key
    end
  end

  #since the post has already been liked by the same user it should not be eligible to be liked.
  test "should not like ineligible post" do

    assert_difference('Like.count', 1) do
      2.times do
        post :like, id: @post.id, user_id: @user.id, user_api_key: @user.api_key
      end
    end
    assert_response :no_content
  end

  #since the post has already be unliked by the same user, it should not be eligible to be liked.
  test "should not unlike ineligible post" do
    assert_difference('Like.count', -1) do 
      2.times do
        post :like, id: @post.id, user_id: @user.id, user_api_key: @user.api_key
      end
    end
end
