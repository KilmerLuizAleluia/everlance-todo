class SessionsController < ApplicationController
  def create
    @user = User.find_by(email: session_params[:email].downcase)
    if @user && @user.authenticate(session_params[:password])
      sign_in
    else
      render
    end
  end

  def destroy
    sign_out
    render json: { message: 'Signed out!' }, status: :ok
  end

  private def session_params
    params.permit(:email, :password)
  end
end
