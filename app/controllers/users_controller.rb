class UsersController < ApplicationController
  before_filter :authorize, :except => [:new, :create]

  def index
    @url = Url.new
  end

  def new
    redirect_to login_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome #{user_params[:first_name]} to lycent. Start shortening!"
      redirect_to root_path
    else
      flash[:danger] = "One or more required fields are missing"
      redirect_to login_path
    end
  end

  def show
    @urls = @current_user.urls
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar)
  end
end
