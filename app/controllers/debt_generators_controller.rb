#####
#
# DebtGeneratorsController
#
# Why does this class exist?
#
# Allows the operator to search for properties that have have charges owing.
# These charges become debt if the operators 'generates the debt'.
#
# How does this fit into the larger system?
#
# This is the accounts portion of the application.
# This controller uses DebtGenerator to take due charges and turn them into
# debts (see DebtGenerator).
# Charges are applied to a properties account (see Charge.rb for more info).
# Charges that have become due and selected by the operator become debts on
# the properties account.
#
#####
#
class DebtGeneratorsController < ApplicationController
  def index
    @debt_generators = DebtGenerator.latest_debt_generated(10)
  end

  def new
    @debt_generator = DebtGenerator.new
  end

  def create
    if search_debts?
      search_debts
    else
      create_debts
    end
  end

  private

  def search_debts?
    params[:commit] == 'Search'
  end

  def search_debts
    @debt_generator = DebtGenerator.new debt_generator_search_params
    @debt_generator.generate
    @debt_generator.valid?
    render :new
  end

  def create_debts
    if generate_debts.save
      redirect_to debt_generators_path, notice: success_message
    else
      render :new
    end
  end

  def generate_debts
    DebtGenerator.new debt_generator_params
  end

  def debt_generator_params
    params.require(:debt_generator)
      .permit debt_generator, debts_attributes: debt_params
  end

  def debt_generator_search_params
    params.require(:debt_generator).permit debt_generator
  end

  def debt_generator
    %i(id search_string start_date end_date)
  end

  def debt_params
    %i(account_id charge_id id on_date amount)
  end

  def success_message
    'Debts successfully created!'
  end
end
