####
#
# Agent
#
# Provides a contact, agent, address spearate from the property
#
# Agent provides the property with a separate contact address
# if it is needed.
#
####
#
class Agent < ActiveRecord::Base
  belongs_to :property, inverse_of: :agent
  include Contact
  validates :entities, presence: true, if: :use_profile?
  before_validation :clear_up_form

  def bill_to
    use_profile? ? self : property
  end

  def prepare_for_form
    prepare_contact
  end

  def clear_up_form
    if use_profile?
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
