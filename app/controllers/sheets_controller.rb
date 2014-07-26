###
#
# SheetsController
#
# Restful actions on the Sheets resource
#
# Sheets are used to create invoices,
# they hold data needed to produce heading,
# Adam's address, notes and items on onvoice and
# notice of rent due.
#
####
#
class SheetsController < ApplicationController
  def index
    @sheets = Sheet.all
  end

  def show
    @sheet = Sheet.find params[:id]
  end

  def new
    @sheet = Sheet.new
  end

  def create
    @sheet = Sheet.new sheets_params
    if @sheet.save
      redirect_to sheets_path, notice: 'Invoice information successfully ' \
                                       'created!'
    else
      render :new
    end
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

  def destroy
    @sheet = Sheet.find(params[:id])
    alert_message = sheet_deleted_message
    @sheet.destroy
    redirect_to sheets_path, alert: alert_message
  end

  private

  def sheets_params
    params.require(:sheet)
    .permit  :invoice_name, :phone, :vat,
             address_attributes: address_params,
             notices_attributes: notices_params
  end

  def notices_params
    %i(id instruction clause proxy)
  end
end
