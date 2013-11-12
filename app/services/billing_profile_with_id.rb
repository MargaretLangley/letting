require_relative '../../lib/modules/method_missing'
####
#
# BillingProfileWith
#
# Makes a BillingProfile hold a unique identifier.
#
# Import records for BillingProfiles do not have a human_ref that identifies
# them. The identifier, instead, comes from the Property's human_ref.
#
# Identifying a BillingProfile by the human_ref is only required during the
# import process. To achieve this I associate the human id of the property
# during the import with this service class.
#
####
#
class BillingProfileWithId
  include MethodMissing
  attr_accessor :human_ref

  def initialize billing_profile = BillingProfile.new
    @source = billing_profile
  end
end
