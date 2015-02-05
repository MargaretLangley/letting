####
#
# InvocingHelper
#
#
####
#
module InvoicingHelper
  def default_date_link
    link_to " or default to the next #{Invoicing::WEEKS_AHEAD} weeks",
            '#',
            title: 'default dates',
            class: 'js-toggle  inverted-link'
  end

  def choosing_dates_link
    link_to 'or choose dates',
            '#',
            title: 'Choose Dates with calendar',
            class: 'js-toggle  inverted-link'
  end

  def invoicing_start_date
    invoicing_default_start_date
  end

  def invoicing_end_date
    invoicing_default_end_date
  end

  def invoicing_default_start_date
    Time.zone.today.to_s
  end

  def invoicing_default_end_date
    (Time.zone.today + Invoicing::WEEKS_AHEAD.weeks).to_s
  end
end
