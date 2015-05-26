class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  #log the user in and give them a temporary api-key
  def get_api_key
    matching_user = User.find_by(id: user_params[:id])
    if matching_user

      auth_result = matching_user.authenticate(user_params[:password])

      if !!auth_result

        render plain: auth_result.api_key, status: 200
      else
        render json: auth_result, status: 400
      end
    end
  end

  # GET /users
  # GET /users.json
  def index
    #show 20 users.
    @users = User.first(20)

    render json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if !!@user.authenticate_api_key(params[:user_api_key])
      if @user.update(user_params)
        head :no_content
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      head :unauthorized
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    head :no_content
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:user_api_key, :user, :id)
      params[:user].permit(:username, :email, :password, :password_confirmation)
    end
end
