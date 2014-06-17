class Sheet < ActiveRecord::Base
  validates :invoice_name, presence: true
  validates :phone, presence: true
  validates :vat, presence: true
  has_one :address, class_name: 'Address',
                    dependent: :destroy,
                    as: :addressable
  accepts_nested_attributes_for :address, allow_destroy: true
  has_many :notices
  accepts_nested_attributes_for :notices, allow_destroy: true
end