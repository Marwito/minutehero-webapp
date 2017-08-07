class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_headers
  include Pundit

  protected

  def authenticate_inviter!
    redirect_to root_url, alert: 'Access Denied' unless current_user.admin?
    super
  end

  private

  def set_cache_headers
    response.headers['Cache-Control'] = 'no-cache, no-store'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name,
                                                       :last_name, :country])
    devise_parameter_sanitizer
      .permit(:account_update, keys: [:first_name, :last_name, :country,
                                      :time_zone, :company, :password])

    devise_parameter_sanitizer.permit(:invite, keys: [:first_name,
                                                      :last_name])
  end
end
