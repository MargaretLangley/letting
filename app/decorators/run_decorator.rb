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

  def run
    @source
  end

  def initialize run
    @source = run
  end

  def activity
    run.last? ? ' active' : ''
  end

  def invoice_date
    I18n.l run.invoice_date, format: :short
  end
end
