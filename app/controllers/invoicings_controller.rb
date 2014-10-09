####
#
# Invoicing Controller
#
# Invoicing for printing batches of invoices.
#
####
#
class InvoicingsController < ApplicationController
  def index
    @invoicings = Invoicing.page(params[:page]).load.order(start_date: :desc)
  end

  def show
    @invoicing = Invoicing.find params[:id]
  end

  def new
    @invoicing = Invoicing.new property_range: params[:search_terms],
                               start_date: params[:start_date],
                               end_date: params[:end_date]
    @invoicing.generate if @invoicing.invoiceable?
  end

  def create
    @invoicing = Invoicing.new invoicing_params
    @invoicing.generate if @invoicing.invoiceable?
    if @invoicing.save
      redirect_to new_invoicing_path, notice: 'Invoicing successfully created!'
    else
      render :new
    end
  end

  private

  def invoicing_params
    params.require(:invoicing).permit :property_range,
                                      :start_date,
                                      :end_date
  end
end
