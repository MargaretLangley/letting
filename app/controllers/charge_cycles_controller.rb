####
#
# ChargeCyclesController
#
# Why does this class exist?
#
# To allow the creation and update of charges in the accounts system
#
# How does this fit into the larger system?
#
# Charge cycles are used in the ledger accounts to determine
# when a charge becomes due
#
####
#
class ChargeCyclesController < ApplicationController
  def index
    @charge_cycles = ChargeCycle.order(:order)
  end

  def show
    @charge_cycle = ChargeCycle.find params[:id]
  end

  def new
    @charge_cycle = ChargeCycle.new
    @charge_cycle.prepare
  end

  def create
    @charge_cycle = ChargeCycle.new charge_cycles_params
    if @charge_cycle.save
      redirect_to charge_cycles_path,
                  flash: { save: charge_cycle_created_message }
    else
      @charge_cycle.prepare
      render :new
    end
  end

  def edit
    @charge_cycle = ChargeCycle.find params[:id]
    @charge_cycle.prepare
  end

  def update
    @charge_cycle = ChargeCycle.find params[:id]
    @charge_cycle.assign_attributes charge_cycles_params
    if @charge_cycle.save
      redirect_to charge_cycles_path,
                  flash: { save: charge_cycle_updated_message }
    else
      render :edit
    end
  end

  def destroy
    @charge_cycle = ChargeCycle.find(params[:id])
    @charge_cycle.destroy
    redirect_to charge_cycles_path, alert: charge_cycle_deleted_message
  end

  private

  def charge_cycles_params
    params
    .require(:charge_cycle)
    .permit :name, :order,
            due_ons_attributes: [:id, :charge_cycle_id, :day,
                                 :month, :year]
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
