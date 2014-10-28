####
#
# CyclesController
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
class CyclesController < ApplicationController
  def index
    @cycles = Cycle.order(:order)
  end

  def show
    @cycle = Cycle.find params[:id]
  end

  def new
    @cycle = Cycle.new cycle_type: params[:cycle_type]
    @cycle.prepare
  end

  def create
    @cycle = Cycle.new cycles_params
    @cycle.prepare
    if @cycle.save
      redirect_to cycles_path,
                  flash: { save: cycle_created_message }
    else
      render :new
    end
  end

  def edit
    @cycle = Cycle.find params[:id]
    @cycle.prepare
  end

  def update
    @cycle = Cycle.find params[:id]
    @cycle.assign_attributes cycles_params
    if @cycle.save
      redirect_to cycles_path,
                  flash: { save: cycle_updated_message }
    else
      render :edit
    end
  end

  def destroy
    @cycle = Cycle.find(params[:id])
    @cycle.destroy
    redirect_to cycles_path, alert: cycle_deleted_message
  end

  private

  def cycles_params
    params.require(:cycle)
          .permit :name,
                  :charged_in_id,
                  :order,
                  :cycle_type,
                  due_ons_attributes: [:id,
                                       :cycle_id,
                                       :day,
                                       :month,
                                       :year]
  end

  def identity
    "Charge Cycle '#{@cycle.name} #{@cycle.order}'"
  end

  def cycle_created_message
    "#{identity} successfully created!"
  end

  def cycle_updated_message
    "#{identity} successfully updated!"
  end

  def cycle_deleted_message
    "#{identity} successfully deleted!"
  end
end
