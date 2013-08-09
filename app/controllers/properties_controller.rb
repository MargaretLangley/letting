class PropertiesController < ApplicationController

  def index
    @properties = Property.includes(:address).page(params[:page]).load
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
        permit :human_property_id,
          address_attributes: address_params,
          entities_attributes: entities_params,
          billing_profile_attributes: billing_profile_params
          # Note for collection of entities you need to return :id as well
          # Note saw '_destroy' in the attributes
    end

    def billing_profile_params
      [ :id, :property_id, :use_profile,
         address_attributes: address_params,
         entities_attributes: entities_params
      ]
    end

end
