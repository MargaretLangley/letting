class BillingProfile < ActiveRecord::Base
  include Contact
  belongs_to :property
end
