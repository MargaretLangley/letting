####
#
# InvoiceText
#
# Invoice Text holds the general information needed for an
# invoice printout, excluding individual account
# and property information. Allows editing of
# this information,
# Front page includes the agent F&L Adams details,
# and text needed on 1st page of invoice
# Back page holds details of 'Notice of Rent Due,'
# only used for Ground Rent.
#
####
#
class InvoiceText < ActiveRecord::Base
  validates :invoice_name, :description, :heading1, :phone, :vat,
            presence: true
  has_one :address, class_name: 'Address',
                    dependent: :destroy,
                    as: :addressable
  accepts_nested_attributes_for :address, allow_destroy: true
  has_many :guides, dependent: :destroy
  accepts_nested_attributes_for :guides, allow_destroy: true
  has_many :invoices, through: :letters
  has_many :letters, dependent: :destroy
end
