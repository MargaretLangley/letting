####
#
# ChargeCyclesController
#
# Why does this class exist?
#
#
#
# How does this fit into the larger system?
#
#
#
####
#
class ChargeCyclesController < ApplicationController

  def index
    @charge_cycles = ChargeCycle.all
  end

  def new
    @charge_cycle = ChargeCycle.new
  end

  def edit
    @charge_cycle = ChargeCycle.find params[:id]
  end

  def create
    @charge_cycle = ChargeCycle.new charge_cycles_params
    if @charge_cycle.save
      redirect_to charge_cycles_path, notice: charge_cycle_created_message
    end
  end

  def destroy
    @charge_cycle = ChargeCycle.find(params[:id])
    alert_message = charge_cycle_deleted_message
    @charge_cycle.destroy
    redirect_to charge_cycles_path, alert: alert_message
  end

  private

  def charge_cycles_params
    params
    .require(:charge_cycle)
    .permit(:name, :order)
  end

  def identy
    "Charge Cycle '#{@charge_cycle.name} #{@charge_cycle.order}'"
  end

  def charge_cycle_created_message
    "#{identy} successfully created!"
  end

  def charge_cycle_updated_message
    "#{identy} successfully updated!"
  end

  def charge_cycle_deleted_message
    "#{identy} successfully deleted!"
  end

end
