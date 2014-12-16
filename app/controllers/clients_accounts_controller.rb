####
#
# ClientsController
#
# Why does this class exist?
#
# To give Clients Cround Rent Accounts for both Mar/Sep & June/Dec due dates
#
# Client resource covers name, address and properties that the clients
# own and get payments from.
####
#
class ClientsAccountsController < ApplicationController
  def show
    @client = Client.includes(properties: [:address, :account]).find params[:id]
    params[:start_date] ||= Date.new(2014, 1, 1)
    params[:end_date] ||= Date.new(2015, 2, 28)
  end

  private

  def clients_params
    params
      .require(:client)
      .permit :human_ref,
              address_attributes: address_params,
              entities_attributes: entities_params
  end

  def identity
    "Client #{@client.human_ref}, #{@client.entities.full_name}"
  end
end
