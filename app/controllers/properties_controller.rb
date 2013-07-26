class PropertiesController < ApplicationController

  def index
    @properties = Property.all
  end
end
