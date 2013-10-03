class DebtGeneratorsController < ApplicationController
  def index
    @debt_generators = DebtGenerator.latest_debt_generated(10)
  end

  def new
    @debt_generator =
      DebtGenerator.new search_string: params[:search],
                        start_date:    params[:search_start_date],
                        end_date:      params[:search_end_date]
    @debt_generator.generate
    if params[:search].present? && @debt_generator.debtless?
      flash.now.notice =  no_properties_error
    end
  end

  def create
    @debt_generator = DebtGenerator.new debt_generator_params
    if @debt_generator.save
      redirect_to debt_generators_path, notice: 'Debts successfully created!'
    else
      render :new
    end
  end

  private

  def property_create_debts_between property, date_range
    property.account.generate_debts_for date_range
  end

  def debt_generator_params
    params.require(:debt_generator)
      .permit :id,
              :search_string,
              :start_date,
              :end_date,
              debts_attributes: debt_params
  end

  def debt_params
    [:account_id, :charge_id, :id, :on_date, :amount]
  end

  def no_properties_error
    "No properties matching '#{params[:search]}' " +
    "between #{params[:search_start_date]} and " +
    "#{params[:search_end_date]} require charges."
  end
end
