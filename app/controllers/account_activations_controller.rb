class AccountActivationsController < ApplicationController
  before_action :load_user, only: :edit

  def edit
    active_account if !@user.activated? && @user.authenticated?(:activation,
                                                                params[:id])
  end

  private

  def active_account
    @user.activate
    log_in @user
    flash[:success] = t ".account_activated"
    redirect_to root_path
  end

  def load_user
    return if @user = User.find_by(email: params[:email])

    flash[:danger] = t ".bad_request"
    redirect_to root_path
  end
end
