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
  def client_list
    Client.order(:human_ref).map do |client|
      {
        label: "#{client.human_ref} #{client.full_name}",
        value: client.id
      }
    end
  end

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
end
