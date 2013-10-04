class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authorize

  delegate :allow?, to: :current_permission
  helper_method :allow?

  protected

  def address_params
    [:county, :district, :flat_no, :house_name,
     :road,   :road_no,  :town,    :type,       :postcode]
  end

  def entities_params
    [:entity_type, :_destroy, :id, :title, :initials, :name]
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def authorize
    unless current_permission.allow? params[:controller], params[:action]
      redirect_to login_path, notice: not_logged_in_message
    end
  end

  def not_logged_in_message
    'Not logged in. Please login to use the application.'
  end

end
