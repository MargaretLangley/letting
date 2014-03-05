###
#
# SheetsController
#
# Why does this class exist?
#
# To Update invoice sheet details
#
# How does this fit into the larger system?
#
# Sheets are used to create invoices.
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
    @sheet.prepare_for_form
  end

  def create
    @sheet = Sheet.new sheets_params
    if @sheet.save
      redirect_to sheets_path, notice: "Invoice information successfully created!"
    else
      @sheet.prepare_for_form
      render :new
    end

  end

  def edit
    @sheet = Sheet.find params[:id]
    @sheet.prepare_for_form
  end

  def update
    @sheet = Sheet.find params[:id]
    if @sheet.update sheets_params
      redirect_to sheets_path, notice: "Invoice information successfully updated!"
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
    params
    .require(:sheet)
    .permit  :inv_name,
             address_attributes: address_params
  end

end

