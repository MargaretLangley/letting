class BillingProfile < ActiveRecord::Base
  belongs_to :property, inverse_of: :billing_profile
  include Contact
  validates :entities, presence: true, if: :use_profile?
  before_validation :clear_up_after_form

  attr_accessor :human_id

  def bill_to
    use_profile? ? self : property
  end

  def prepare_for_form
    use_profile = false if use_profile.nil?
    prepare_contact
  end

  def clear_up_after_form
    if use_profile?
      entities.clean_up_form
    else
      entities.destroy_all
      destroy_address unless address.nil?
    end
  end

  private

    def destroy_address
      address.mark_for_destruction
    end
end
