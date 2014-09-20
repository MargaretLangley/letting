####
#
# Sheet
#
# Sheet holds the general information needed for an
# invoice printout, excluding individual account
# and property information. Allows editing of
# this information,
# 1st page includes the agent F&L Adams details,
# and text needed on invoice
# 2nd page holds details of 'Notice of Rent Due,'
# only used for Ground Rent.
#
####
#
class Sheet < ActiveRecord::Base
  validates :invoice_name, presence: true
  validates :phone, presence: true
  validates :vat, presence: true
  has_one :address, class_name: 'Address',
                    dependent: :destroy,
                    as: :addressable
  accepts_nested_attributes_for :address, allow_destroy: true
  has_many :notices, -> { order(:created_at) }, dependent: :destroy
  accepts_nested_attributes_for :notices, allow_destroy: true
end
