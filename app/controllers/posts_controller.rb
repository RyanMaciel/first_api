class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy, :like, :unlike]
  before_action :authenticate_user, only: [:create, :update, :destroy, :like, :unlike]
  include LocationModule

  # GET /posts
  # GET /posts.json
  def index

    #If latitude and longitude params are provided, return posts within a certain distance
    if params[:latitude] && params[:longitude]
      posts_to_render = []
      Post.find_each do |post|
        #distance is 5km
        if distance(params[:latitude].to_f, params[:longitude].to_f, post) <= 5
          posts_to_render << post
        end
      end
      
      render json: posts_to_render
    else
      #show only 20 posts
      @posts = Post.first(20)
      render json: @posts
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    render json: @post
  end

  # POST /posts
  # POST /posts.json
  def create
    if @user
      @post = Post.new(post_params)
      @post.user = @user
      if @post.save
        render json: @post, status: :created, location: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end
  end


  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      head :no_content
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    head :no_content
  end

  #need to be re-implemented
  def like

  end

  def unlike
    
  end

  private

    def set_post
      if Post.count > 0
        @post = Post.find(params[:id])
      end
    end

    def post_params

      #the order here is relevent, the second line is an implicit return
      params.permit(:user_id, :user_api_key)
      params.require(:post).permit(:image_url, :latitude, :longitude)

    end

    #find the user by id and authenticate them. return true if succesful, end the request if not.
    #this needs to also make sure that the user id matches the owner of the post.
    #Additionally defines the @user variable and ensures it is non-nil (the else would be called if it was.)
    def authenticate_user()
      @user = User.find(params[:user_id])
      if (!@post || @user == @post.user) && !!@user.authenticate_api_key(params[:user_api_key])
        return true
      end
      head :unauthorized
    end
    
end
