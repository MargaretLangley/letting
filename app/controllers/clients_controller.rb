class ClientsController < ApplicationController

  def index
    @clients = Client.all
  end

  def show
    @client = Client.find params[:id]
  end

  def edit
    @client = Client.find params[:id]
  end

  def update
    @client = Client.find params[:id]
    if @client.update clients_params
      redirect_to clients_path, notice: 'Client successfully updated!'
    else
      render :edit
    end
  end

  private

    def clients_params
      params.require(:client).
        permit :human_client_id,
          address_attributes: [:addressable_id, :addressable_type, :county, :district, :flat_no, :house_name, :road, :road_no, :town, :postcode ],
          entities_attributes: [:entitieable_id, :entitieable_type, :id, :title, :initials, :name]
    end
end