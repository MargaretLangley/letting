class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def address_params
    [ :county, :district, :flat_no, :house_name, :road, :road_no, :town, :type, :postcode ]
  end

  def entities_params
    [:id, :title, :initials, :name ]
  end
end
