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

  def run
    @source
  end

  def initialize run
    @source = run
  end

  def style_activity
    run.last? ? ' active' : ''
  end

  def invoice_date
    format_short_date run.invoice_date
  end
end
