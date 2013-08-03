class PropertiesController < ApplicationController

  def index
    @properties = Property.all
  end

  def show
    @property = Property.find params[:id ]
  end

  def new
    @property = Property.new
    @property.prepare_for_form
  end

  def create
    @property = Property.new property_params
    if @property.save
      redirect_to properties_path, notice: 'Property successfully created!'
    else
      @property.prepare_for_form
      render :new
    end
  end

  def edit
    @property = Property.find params[:id]
    @property.prepare_for_form
  end

  def update
    @property = Property.find params[:id]
    if @property.update property_params
      redirect_to properties_path, notice: 'Property successfully updated!'
    else
      render :edit
    end
  end

  def destroy
    @property = Property.find(params[:id])
    @property.destroy
    redirect_to properties_path, alert: 'Property successfully deleted!'
  end

  private

    def property_params
      params.require(:property).
        permit :human_property_reference,
          address_attributes: [:addressable_id, :addressable_type, :county, :district, :flat_no, :house_name, :road, :road_no, :town, :postcode ],
          entities_attributes: [:entitieable_id, :entitieable_type, :id, :title, :initials, :name],
          billing_profile_attributes: [ :id, :property_id, :use_profile,
            address_attributes:  [ :addressable_id, :addressable_type, :county, :district, :flat_no, :house_name, :road, :road_no, :town, :postcode ],
            entities_attributes: [:id, :entitieable_id, :entitieable_type,:title, :initials, :name]
          ]
          # Note for collection of entities you need to return :id as well
          # Note saw '_destroy' in the attributes
    end
end
