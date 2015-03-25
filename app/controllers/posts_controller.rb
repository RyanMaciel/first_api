class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

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
      @posts = Post.all
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
    @post = Post.new(post_params)
    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
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

  private

    def set_post
      if Post.count > 0
        @post = Post.find(params[:id])
      end
    end

    def post_params
      params.require(:post).permit(:image_url, :latitude, :longitude)
    end

 
end
