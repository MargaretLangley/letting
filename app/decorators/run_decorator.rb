require_relative '../../lib/modules/method_missing'

####
#
# AccountDecorator
#
# AccountDecorator prepares credits and debits and allows them
# to be viewed
#
# rubocop: disable Style/TrivialAccessors
####
#
class RunDecorator
  include MethodMissing
  include DateHelper
  attr_reader :index

  def run
    @source
  end

  def initialize run, index
    @source = run
    @index = index + 1
  end

  # Name appearing on the top of a tab
  #
  def tab_index_name
    "#{index.ordinalize} Invoice"
  end

  # Outputs html id for JS
  #
  def tab_index_id
    "#tab-content#{index}"
  end

  def style_activity
    run.last? ? ' js-active-tab' : ''
  end

  def invoice_date
    format_short_date run.invoice_date
  end
end
