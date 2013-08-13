class BillingProfile < ActiveRecord::Base
  belongs_to :property
  include Contact
  validates :entities, :presence => true, if: :use_profile?
  before_validation :clear_up_after_form

  # if we have
  def bill_to
    use_profile? ? self : property
  end

  def prepare_for_form property
    # When saved it will set the property. However, before it is
    # saved. property is nil. I'm setting it here so not nil when
    # property is a new_record
    self.property = property
    use_profile = false if use_profile.nil?
    prepare_contact
  end

  def clear_up_after_form
    if use_profile?
      entities_for_destruction :empty?
    else
      address_for_destruction unless self.address.nil?
      entities_for_destruction :all?
    end
  end

  private
    def address_for_destruction
      self.address.mark_for_destruction
    end
end
