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
    @charge_cycle = ChargeCycle.new period_type: params[:period]
    @charge_cycle.prepare
  end

  def create
    @charge_cycle = ChargeCycle.new charge_cycles_params
    @charge_cycle.prepare
    if @charge_cycle.save
      redirect_to charge_cycles_path,
                  flash: { save: charge_cycle_created_message }
    else
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
    .permit :name, :order, :period_type,
            due_ons_attributes: [:id, :charge_cycle_id, :day,
                                 :month, :year]
  end

  def identity
    "Charge Cycle '#{@charge_cycle.name} #{@charge_cycle.order}'"
  end

  def charge_cycle_created_message
    "#{identity} successfully created!"
  end

  def charge_cycle_updated_message
    "#{identity} successfully updated!"
  end

  def charge_cycle_deleted_message
    "#{identity} successfully deleted!"
  end
end
