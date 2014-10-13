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
    @invoicings = Invoicing.page(params[:page]).load.order(period_first: :desc)
  end

  def show
    @invoicing = Invoicing.find params[:id]
  end

  def new
    @invoicing = Invoicing.new property_range: params[:search_terms],
                               period: params[:start_date]..params[:end_date]
    @invoicing.generate
  end

  def create
    @invoicing = Invoicing.new invoicing_params
    @invoicing.generate
    if @invoicing.save
      redirect_to new_invoicing_path, notice: 'Invoicing successfully created!'
    else
      render :new
    end
  end

  private

  def invoicing_params
    params.require(:invoicing).permit :property_range,
                                      :period_first,
                                      :period_last
  end
end
