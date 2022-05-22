class UsersController < ApplicationController
  before_action :authorize, except: :create

  def create
    render json: ::CreateUserService.new(params: user_params).call, status: :created
  rescue StandardError => error
    render json: { errors: error.message }, status: :unprocessable_entity
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
