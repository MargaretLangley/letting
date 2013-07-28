class PropertiesController < ApplicationController

  def index
    @properties = Property.all
  end

  def show
    @property = Property.find params[:id ]
  end

  def edit
    @property = Property.find params[:id]
  end

  def update
    @property = Property.find params[:id]
    @property.update property_params
    redirect_to properties_path, notice: 'Property successfully updated!'
  end

  private

    def property_params
      params.require(:property).
        permit :human_property_reference,
          address_attributes: [:county, :district, :flat_no, :house_name, :road, :road_no, :town, :postcode ],
          entities_attributes: [:id, :title, :initials, :name]
          # Note for collection of entities you need to return :id as well
          # Note saw '_destroy' in the attributes
    end
end
