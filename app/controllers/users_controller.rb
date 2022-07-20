class UsersController < ApplicationController
  before_action :load_user, except: %i(new create)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.all
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t ".alert_update_user_success"
      redirect_to users_path
    else
      flash.now[:danger] = t ".alert_update_user_fail"
      render :edit
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".alert_save_user_success"
      redirect_to users_path
    else
      flash.now[:danger] = t ".alert_save_user_fail"
      render :new
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_user_success"
    else
      flash[:danger] = t ".delete_user_fail"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(User::FIELD_PERMIT)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash.now[:danger] = t "not_find_user"
    render :index
  end
end
