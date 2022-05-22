class UsersController < ApplicationController
  before_action :authorize, except: [:create]

  def show
    @user = User.find(user_params)
    render json: @user, status: :ok
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
