class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def address_params
    [ :addressable_id, :addressable_type, :county, :district, :flat_no, :house_name, :road, :road_no, :town, :type, :postcode ]
  end

  def entities_params
    [:entitieable_id, :entitieable_type, :id, :title, :initials, :name ]
  end
end
