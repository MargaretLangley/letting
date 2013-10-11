####
#
# BillingProfileWith
#
# Makes a BillingProfile hold a unique identifier.
#
# Import records for BillingProfiles do not have a human_id that identifies
# them. The identifier, instead, comes from the Property's human_id.
#
# Identifying a BillingProfile by the human_id is only required during the
# import process. To achieve this I associate the human id of the property
# during the import with this service class.
#
####
#
class BillingProfileWithId

  attr_accessor :human_id

  def initialize billing_profile = BillingProfile.new
    @billing_profile = billing_profile
  end

  def method_missing method_name, *args, &block
    @billing_profile.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @billing_profile.respond_to?(method_name, include_private) || super
  end

end