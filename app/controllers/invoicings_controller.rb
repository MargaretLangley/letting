####
#
# Invoicing Controller
#
# Invoicing for printing batches of invoices.
#
####
#
class InvoicingsController < ApplicationController
  def new
    @invoicing = Invoicing.new start_date: params[:start_date],
                               end_date: params[:end_date]
    @invoicing.generate account_ids: params[:id] if params[:id]
  end

  def create
  end
end
