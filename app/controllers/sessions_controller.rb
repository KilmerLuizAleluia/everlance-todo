class SessionsController < ApplicationController
  def create
    @user = User.find_by(email: session_params[:email].downcase)
    if @user && @user.authenticate(session_params[:password])
      sign_in
      render json: { message: 'User logged in.', user_id: @user.id }, status: :ok
    else
      render json: { message: 'Wrong email or password.' }, status: :unauthorized
    end
  end

  def destroy
    if @user
      sign_out
      render json: { message: 'User logged out.' }, status: :ok
    else
      render json: { message: 'No user is logged in.' }, status: :not_modified
    end
  end

  private def session_params
    params.permit(:email, :password)
  end
end
