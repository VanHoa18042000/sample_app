class UsersController < ApplicationController
  def index; end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash.now[:danger] = t ".not_find_user"
    render :index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".alert_save_user_success"
      redirect_to users_path
    else
      flash.now[:danger] = @user.errors.full_messages.first.to_s
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(User::USER_ATTRS)
  end
end
