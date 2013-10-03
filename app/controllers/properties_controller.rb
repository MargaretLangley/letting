class PropertiesController < ApplicationController

  def index
    @properties = Property.search(search_param).page(params[:page]).load
    redirect_to edit_property_path @properties.first if unique_search?
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
      redirect_to properties_path, notice: "#{@property.human_id} property successfully created!"
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
      redirect_to properties_path, notice: "#{@property.human_id} property successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @property = Property.find(params[:id])
    @property.destroy
    redirect_to properties_path, alert: "#{@property.human_id} property successfully deleted!"
  end

  private

    def unique_search?
      @properties.size == 1 && search_param.present?
    end

    def search_param
      params[:search]
    end

    def property_params
      params.require(:property)
        .permit :human_id,
                :client_id,
          address_attributes: address_params,
          entities_attributes: entities_params,
          billing_profile_attributes: billing_profile_params,
          account_attributes: account_params
          # Note for collection of entities you need to return :id as well
          # Note saw '_destroy' in the attributes
    end

    def billing_profile_params
      [:id, :property_id, :use_profile,
        address_attributes: address_params,
        entities_attributes: entities_params
      ]
    end

    def account_params
      [:id, :property_id, charges_attributes: charges_params]
    end

    def charges_params
      [:id, :charge_type, :due_in, :amount, :_destroy,
        due_ons_attributes: due_on_params
      ]
    end

    def due_on_params
      [:id, :day, :month]
    end
end
