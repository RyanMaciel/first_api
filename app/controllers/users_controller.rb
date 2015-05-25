class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def login
    email_matching_user = User.find_by email: user_params[:email]
    if email_matching_user
      auth_result = email_matching_user.authenticate("foobar")

      if !!auth_result
        render json: auth_result, status: 200
      else
        render json: auth_result, status: 400
      end
    end
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all

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
    @user = User.find(params[:id])

    if @user.update(user_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
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
      params[:user].permit(:username, :email, :password, :password_confirmation)
    end
end
