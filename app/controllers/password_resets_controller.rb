class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i( crreate edit update)
  before_action :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t "check_mail"
    redirect_to root_url
  end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t(".cant_empty")
      render :edit
    elsif @user.update(user_params)
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = t ".success_reset"
      redirect_to login_path
    else
      flash.now[:danger] = t ".fail_reset"
      render :new
    end
  end

  def edit; end

  private

  def get_user
    @user = User.find_by(email: params[:password_reset][:email]&.downcase ||
    params[:email]&.downcase)
    return if @user

    redirect_to root_path
    flash[:danger] = t ".not_find_user"
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset,
                                                         params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".expiration"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
