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
    @invoicings = Invoicing.page(params[:page]).default.load
  end

  def show
    @invoicing = Invoicing.find params[:id]
  end

  def new
    @invoicing = Invoicing.new \
                   property_range: SpaceOut.process(params[:search_terms]),
                   period: params[:start_date]..params[:end_date]
    @invoicing.generate
  end

  def create
    @invoicing = Invoicing.new invoicing_params
    @invoicing.generate invoice_date: params[:invoice_date]
    if @invoicing.save
      redirect_to new_invoicing_path, notice: 'Invoicing successfully created!'
    else
      render :new
    end
  end

  def update
    @invoicing = Invoicing.find params[:id]
    @invoicing.generate
    @invoicing.save
    redirect_to print_path @invoicing
  end

  def destroy
    @invoicing = Invoicing.find params[:id]
    alert_message = deleted_message
    @invoicing.destroy
    redirect_to invoicings_path, alert: alert_message
  end

  private

  def invoicing_params
    params.require(:invoicing).permit invoicing_attributes
  end

  def invoicing_attributes
    %i(property_range period_first period_last)
  end

  def identity
    invoicing = InvoicingIndexDecorator.new @invoicing
    "Range #{invoicing.property_range}, period: #{invoicing.period_between}"
  end

  def deleted_message
    "#{identity} successfully deleted!"
  end
end
