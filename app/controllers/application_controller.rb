class ApplicationController < ActionController::API
  include SessionsHelper

  def authorize
    unless logged_in?
      render json: { message: 'should log in first' }, status: 401
    end
  end
end
