####
#
# PaymentHelper
#
# Shared helper methods
#
####
#
module PaymentHelper
  def payment_date(date:)
    params[:date] == date.to_s  ? 'pick-out  text-normal' : ''
  end
end
