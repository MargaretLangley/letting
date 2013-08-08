class ClientsController < ApplicationController

  def index
    @clients = Client.includes(:address).load
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
      redirect_to clients_path, notice: 'Client successfully created!'
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
      redirect_to clients_path, notice: 'Client successfully updated!'
    else
      render :edit
    end
  end


  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    redirect_to clients_path, alert: 'Client successfully deleted!'
  end

  private

    def clients_params
      params.require(:client).
        permit :human_client_id, address_attributes: address_params, entities_attributes: entities_params
    end
end