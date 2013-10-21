#####
#
# DebitGeneratorsController
#
# Why does this class exist?
#
# Allows the operator to search for properties that have have charges owing.
# These charges become debit if the operators 'generates the debit'.
#
# How does this fit into the larger system?
#
# This is the accounts portion of the application.
# This controller uses DebitGenerator to take due charges and turn them into
# debits (see DebitGenerator).
# Charges are applied to a properties account (see Charge.rb for more info).
# Charges that have become due and selected by the operator become debits on
# the properties account.
#
#####
#
class DebitGeneratorsController < ApplicationController
  MAX_DISPLAYED_DEBITS = 10
  def index
    @debit_generators = DebitGenerator
     .latest_debit_generated(MAX_DISPLAYED_DEBITS)
  end

  def new
    @debit_generator = DebitGenerator.new
  end

  def create
    if search_debits?
      search_debits
    else
      create_debits
    end
  end

  private

  def search_debits?
    params[:commit] == 'Search'
  end

  def search_debits
    @debit_generator = DebitGenerator.new debit_generator_search_params
    @debit_generator.generate
    @debit_generator.valid?
    render :new
  end

  def create_debits
    if generate_debits.save
      redirect_to debit_generators_path, notice: success_message
    else
      render :new
    end
  end

  def generate_debits
    DebitGenerator.new debit_generator_params
  end

  def debit_generator_params
    params.require(:debit_generator)
      .permit debit_generator, debits_attributes: debit_params
  end

  def debit_generator_search_params
    params.require(:debit_generator).permit debit_generator
  end

  def debit_generator
    %i(id search_string start_date end_date)
  end

  def debit_params
    %i(account_id charge_id id on_date amount)
  end

  def success_message
    'Debits successfully created!'
  end
end
