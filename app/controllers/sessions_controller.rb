class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by_email(session_params[:email])
    if user && user.authenticate(session_params[:password])
      log_in(user)
      redirect_to user_path(user)
    else
      flash[:danger] = "Login failed. Wrong username or password."
      redirect_to login_path
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
