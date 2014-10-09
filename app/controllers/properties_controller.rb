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
    @records = Property.includes(:account, :address, :client, :entities).page(params[:page]).load
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
    %i(id property_id authorized) + [address_attributes: address_params] +
    [entities_attributes: entities_params]
  end

  def account_params
    %i(id property_id) + [charges_attributes: charges_params]
  end

  def charges_params
    %i(id charge_type charge_cycle_id charged_in_id amount dormant)
  end

  def identity
    property = PropertyDecorator.new @property
    "Property 'ID #{property.human_ref}, #{property.abbreviated_address}'"
  end

  def property_created_message
    "#{identity} successfully created!"
  end

  def property_updated_message
    "#{identity} successfully updated!"
  end

  def property_deleted_message
    "#{identity} successfully deleted!"
  end
end
