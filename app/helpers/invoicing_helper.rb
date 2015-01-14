####
#
# InvocingHelper
#
#
####
#
module InvoicingHelper
  def hide_if_invoicing_dates_default
    invoicing_using_default_dates? ? ' js-revealable ' : ''
  end

  def expose_if_invoicing_dates_default
    invoicing_using_default_dates? ? '' : ' js-revealable '
  end

  def invoicing_using_default_dates?
    params[:start_date] == invoicing_default_start_date &&
      params[:end_date] == invoicing_default_end_date
  end

  def invoicing_start_date
    params[:start_date] || invoicing_default_start_date
  end

  def invoicing_end_date
    params[:end_date] || invoicing_default_end_date
  end

  def invoicing_default_start_date
    Time.zone.today.to_s
  end

  def invoicing_default_end_date
    (Time.zone.today + 7.weeks).to_s
  end
end
