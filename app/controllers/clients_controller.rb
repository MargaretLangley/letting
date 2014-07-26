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
    @clients = Client.page(params[:page]).load
  end

  def search
    # What happens for unique_search?
    @clients = Client.search(params[:search]).page(params[:page]).records
    return render action: 'index' if @clients.present?

    if params[:search].present?
      flash.now[:alert] = 'No Matches found. Search again.'
      @clients = Client.page(params[:page]).load
      render :index
    else
      redirect_to clients_path
    end
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
    alert_message = client_deleted_message
    @client.destroy
    redirect_to clients_path, alert: alert_message
  end

  private

  def find_route model
    case params[:search_action]
    when 'show'
      client_path model
    when 'edit'
      edit_client_path model
    else
      clients_path
    end
  end

  def unique_search?
    search_param.present? && @clients.size == 1
  end

  def search_param
    params[:search]
  end

  def clients_params
    params
      .require(:client)
      .permit :human_ref,
              address_attributes: address_params,
              entities_attributes: entities_params
  end

  def identy
    "Client '#{@client.entities.full_name} (id #{@client
      .human_ref})'"
  end

  def client_created_message
    "#{identy} successfully created!"
  end

  def client_updated_message
    "#{identy} successfully updated!"
  end

  def client_deleted_message
    "#{identy} successfully deleted!"
  end
end
