####
#
# ClientsController
#
# Why does this class exist?
#
# To give Clients Ground Rent Accounts for both Mar/Sep & June/Dec due dates
#
# Client resource covers name, address and properties that the clients
# own and get payments from.
####
#
class ClientsAccountsController < ApplicationController
  def show
    params[:start_date] ||= Date.new(2014, 1, 1)
    params[:end_date] ||= Time.zone.today
    @client = Client.includes(properties: [:address, :account]).find params[:id]
    @accounts = ClientAccount.payments client_id: params[:id],
                                       start_date: params[:start_date],
                                       end_date: params[:end_date]
  end
end
