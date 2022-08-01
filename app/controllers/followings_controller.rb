class FollowingsController < ApplicationController
  before_action :logged_in_user, :find_user, only: :index

  def index
    @title = t ".following"
    @pagy, @users = pagy @user.following, items: Settings.admin.user_per_page
    render "users/show_follow"
  end
end
