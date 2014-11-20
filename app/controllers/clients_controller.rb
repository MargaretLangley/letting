####
#
# ClientsController
#
# Why does this class exist?
#
# Restful actions on the Clients resource
#
# Client resource covers name, address and properties that the clients
# own and get payments from.
####
#
class ClientsController < ApplicationController
  def index
    @records = Client.includes(:address).page(params[:page]).load
  end

  def show
    @client = Client.includes(properties: [:address]).find params[:id]
  end

  def new
    @client = Client.new
    @client.prepare_for_form
  end

  def create
    @client = Client.new clients_params
    if @client.save
      redirect_to clients_path, notice: created_message
    else
      @client.prepare_for_form
      render :new
    end
  end

  def edit
    @client = Client.find params[:id]
    @client.prepare_for_form
  end

  def update
    @client = Client.find params[:id]
    if @client.update clients_params
      redirect_to clients_path, notice: updated_message
    else
      render :edit
    end
  end

  def destroy
    @client = Client.find params[:id]
    alert_message = deleted_message
    @client.destroy
    redirect_to clients_path, alert: alert_message
  end

  private

  def clients_params
    params
      .require(:client)
      .permit :human_ref,
              address_attributes: address_params,
              entities_attributes: entities_params
  end

  def created_message
    "#{identity} successfully created!"
  end

  def updated_message
    "#{identity} successfully updated!"
  end

  def deleted_message
    "#{identity} successfully deleted!"
  end

  def identity
    "Client '#{@client.entities.full_name} (id #{@client
      .human_ref})'"
  end
end
