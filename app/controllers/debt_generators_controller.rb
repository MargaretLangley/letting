class DebtGeneratorsController < ApplicationController
  def index
    @debt_generators = DebtGenerator.latest_debt_generated(10)
  end

  def new
    @debt_generator = DebtGenerator.new
    @debt_generator.search_string = params[:search]
    @debt_generator.start_date = search_date_range.begin
    @debt_generator.end_date = search_date_range.end
    properties = []
    properties = Property.search(params[:search]) if params[:search].present?
    if properties.any?
      properties.each do |property|
        @debt_generator.debts << property_create_debts_between(property, search_date_range)
      end
    else
      flash.now.notice = "No properties found. Searched for: '#{params[:search]}'" \
        if params[:search].present?
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

  def search_date_range
    start_date = params[:search_start_date].present? ? \
      Date.parse(params[:search_start_date]) : Date.current
    end_date = params[:search_end_date].present? ? \
      Date.parse(params[:search_end_date]) : Date.current + 8.weeks
    start_date..end_date
  end

  def property_create_debts_between property, date_range
    property.account.generate_debts_for date_range
  end

  def debt_generator_params
    params.require(:debt_generator)
      .permit :id, :search_string, :start_date, :end_date, debts_attributes: debt_params
  end

  def debt_params
    [ :account_id, :charge_id, :id, :on_date, :amount ]
  end
end
