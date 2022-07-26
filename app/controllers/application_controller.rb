class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception
  include SessionsHelper
  include Pagy::Backend

  private
  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale =
      I18n.available_locales.include?(locale) ? locale : I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "please_login"
    redirect_to login_url
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "dont_perform_this_behavior"
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "not_admin"
    redirect_to root_url
  end
end
