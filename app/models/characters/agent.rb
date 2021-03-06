####
#
# Agent
#
# Provides a contact, agent, address separate from the property
#
# Agent provides the property with a separate contact address
# if it is needed.
#
####
#
class Agent < ActiveRecord::Base
  belongs_to :property, inverse_of: :agent
  include Contact
  validates :entities, presence: true, if: :authorized?
  before_validation :clear_up_form

  delegate :full_names, to: :entities
  delegate :text, to: :address, prefix: true

  def bill_to
    authorized? ? self : property
  end

  def to_billing
    return unless authorized
    address.name_and_address name: full_names
  end

  def prepare_for_form
    prepare_contact
  end

  def clear_up_form
    if authorized?
      clean_form
    else
      erase_form
    end
  end

  private

  def clean_form
    entities.clear_up_form
  end

  def erase_form
    entities.destroy_all
    address.clear_up_form unless address.nil?
  end
end
