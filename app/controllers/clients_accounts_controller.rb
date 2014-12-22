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
end
