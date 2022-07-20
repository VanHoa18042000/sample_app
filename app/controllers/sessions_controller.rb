class SessionsController < ApplicationController
  before_action :find_user_by_email, only: :create

  def new; end

  def create
    if @user&.authenticate params[:session][:password]
      check_activated
    else
      flash.now[:danger] = t ".invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def check_activated
    if @user.activated?
      log_in @user
      params[:session][:remember] == "1" ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash[:warning] = t ".account_not_actived"
      redirect_to root_url
    end
  end

  private

  def find_user_by_email
    @user = User.find_by email: params[:session][:email].downcase
    return if @user

    flash[:danger] = t "not_find_user"
    redirect_to root_path
  end
end
