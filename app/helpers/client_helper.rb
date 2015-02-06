####
#
# ClientHelper
#
# Shared helper methods
#
# Add methods to client decorator if it is created.
#
####
#
module ClientHelper
  # Payments Panel visibility
  # Visibility of abbreviated payments
  #
  def payments_contracted_visible
    params[:selected].present?  ? 'js-revealable' : ''
  end

  # Visibility of full payments
  #
  def payments_expanded_visible
    params[:selected].present?  ? '' : 'js-revealable'
  end

  def client_payment_year
    params[:client_payment_year] ||= Time.zone.now.year
  end
end
