###
#
# TeachingHelper
#
####
#
module TeachingHelper
  # Payment Teaching Page
  #
  def pay_human_ref human_ref: Account.first.property.human_ref
    link_to t(human_ref),
            search_path(search_terms: human_ref, search_model: 'Payment')
  end

  def pay_owner owner: Account.first.holder
    link_to 'owner',
            search_path(search_terms: owner, search_model: 'Payment')
  end

  # TODO: search is not working
  #
  def pay_amount amount: Payment.first.amount
    link_to 'amount',
            search_path(search_terms: amount, search_model: 'Payment')
  end

  # Invoicing Teaching Page
  #
  def invoicing_range account_range: Account.first..Account.second,
                      period: '2014-09-23'..'2014-11-18'
    link_to(
      t('Example'),
      search_path(search_terms: "#{account_range.first.property.human_ref}-"\
                                "#{account_range.last.property.human_ref}",
                  start_date: period.first,
                  end_date: period.last)
    )
  end
end
