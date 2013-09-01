class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected

  def address_params
    [ :county, :district, :flat_no, :house_name, :road, :road_no, :town, :type, :postcode ]
  end

  def entities_params
    [:entity_type, :id, :title, :initials, :name]
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
