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
  end

  def create
    @sheet = Sheet.new sheets_params
    if @sheet.save
      redirect_to sheets_path, notice: "#{identy} successfully created!"
    else
      render :new
    end
  end

  def edit
    @user = Sheet.find params[:id]
  end

  def update
    @user = Sheet.find params[:id]
    if @user.update sheets_params
      redirect_to sheets_path, notice: "#{identy} successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @user = Sheet.find(params[:id])
    alert_message = user_deleted_message
    @user.destroy
    redirect_to sheets_path, alert: alert_message
  end

  private

  def user_deleted_message
    "#{identy} successfully deleted!"
  end

end
