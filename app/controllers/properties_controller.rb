####
#
# PropertiesController
#
# Why does this class exist?
#
# Restful actions on the Properties resource
#
# How does this fit into the larger system?
#
# Properties are at the heart of the application - which accounts, tenants,
# agents / addresses are hung off and this is the managing
# controller.
#
####
#
class PropertiesController < ApplicationController
  def index
    @properties = Property.search(search_param).page(params[:page]).load
    redirect_to find_route(@properties.first) if unique_search?
  end

  def show
    @property = PropertyDecorator.new Property.find params[:id]
  end

  def new
    @property = Property.new
    @property.prepare_for_form
  end

  def create
    @property = Property.new property_params
    if @property.save
      redirect_to properties_path, notice: property_created_message
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
      redirect_to properties_path, notice: property_updated_message
    else
      render :edit
    end
  end

  def destroy
    @property = Property.find(params[:id])
    alert_message = property_deleted_message
    @property.destroy
    redirect_to properties_path, alert: alert_message
  end

  private

    def find_route model
      case params[:search_action]
      when 'show'
        property_path model
      when 'edit'
        edit_property_path model
      else
        properties_path
      end
    end

    def unique_search?
      search_param.present? && @properties.size == 1
    end

    def search_param
      params[:search]
    end

    def property_params
      params.require(:property)
        .permit :human_ref,
                :client_id,
                address_attributes:         address_params,
                entities_attributes:        entities_params,
                agent_attributes: agent_params,
                account_attributes:         account_params
    end

    def agent_params
      %i(id property_id use_profile) + [address_attributes: address_params] +
      [entities_attributes: entities_params]
    end

    def account_params
      %i(id property_id) + [charges_attributes: charges_params]
    end

    def charges_params
      %i(id charge_type due_in amount _destroy) +
      [due_ons_attributes: due_on_params]
    end

    def due_on_params
      %i(id day month)
    end

    def identy
      property = PropertyDecorator.new @property
      "Property 'ID #{property.human_ref}, #{property.abbreviated_address}'"
    end

    def property_created_message
      "#{identy} successfully created!"
    end

    def property_updated_message
      "#{identy} successfully updated!"
    end

    def property_deleted_message
      "#{identy} successfully deleted!"
    end
end
