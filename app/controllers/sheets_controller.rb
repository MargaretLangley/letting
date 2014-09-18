###
#
# SheetsController
#
# Restful actions on the Sheets resource
#
# Sheets are used to create invoices,
# they hold data needed to produce heading,
# Adam's address, notes and items on invoice and
# notice of rent due.
#
####
#
class SheetsController < ApplicationController
  def index
    @sheets = Sheet.order(:id)
  end

  def show
    @sheet = Sheet.find params[:id]
  end

  def edit
    @sheet = Sheet.find params[:id]
  end

  def update
    @sheet = Sheet.find params[:id]
    if @sheet.update sheets_params
      redirect_to sheets_path, notice: 'Invoice information successfully ' \
                                       'updated!'
    else
      render :edit
    end
  end

  private

  def sheets_params
    params.require(:sheet)
    .permit  :invoice_name, :phone, :vat,
             :heading1, :heading2,
             :advice1, :advice2,
             address_attributes: address_params,
             notices_attributes: notices_params
  end

  def notices_params
    %i(id instruction clause proxy)
  end
end
