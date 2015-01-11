####
#
# ApplicationController
#
# Base Class for all the applications controller. chiefly it supplies current
# user and authorization.
#
# Application supplies current_user - so a controller and views have a common
# way to access the current user and the authorization system.
#
# The class also provides, eclectically, params used by a few of the classes.
#
#####
#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize

  delegate :allow?, to: :current_permission
  helper_method :allow?

  protected

  def address_params
    %i(county district flat_no house_name nation road road_no town type \
       postcode)
  end

  def entities_params
    %i(entity_type _destroy id title initials name)
  end

  #
  # Messages used in controllers to mark success.
  #
  def created_message
    "#{identity} created!"
  end

  def updated_message
    "#{identity} updated!"
  end

  def deleted_message
    "#{identity} deleted!"
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue
    reset_session
  end
  helper_method :current_user

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def authorize
    return if current_permission.allow? params[:controller], params[:action]
    redirect_to login_path, flash: { problem: not_logged_in_message }
  end

  def not_logged_in_message
    'Not logged in. Please login to use the application.'
  end
end
