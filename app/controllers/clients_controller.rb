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
    @clients = Client.search(search_param).page(params[:page]).load
    redirect_to edit_client_path @clients.first if unique_search?
  end

  def show
    @client = Client.find params[:id]
  end

  def new
    @client = Client.new
    @client.prepare_for_form
  end

  def create
    @client = Client.new clients_params
    if @client.save
      redirect_to clients_path, notice: client_created_message
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
      redirect_to clients_path, notice: client_updated_message
    else
      render :edit
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    redirect_to clients_path, alert: client_deleted_message
  end

  private

    def unique_search?
      search_param.present? && @clients.size == 1
    end

    def search_param
      params[:search]
    end

    def clients_params
      params
        .require(:client)
        .permit :human_id,
                address_attributes: address_params,
                entities_attributes: entities_params
    end

    def client_created_message
      "#{@client.human_id} client successfully created!"
    end

    def client_updated_message
      "#{@client.human_id} client successfully updated!"
    end

    def client_deleted_message
      "#{@client.human_id} client successfully deleted!"
    end
end
