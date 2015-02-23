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
            class: 'js-toggle  plain-link'
  end

  def choosing_dates_link
    link_to 'or choose dates',
            '#',
            title: 'Choose Dates with calendar',
            class: 'js-toggle  plain-link'
  end
end
