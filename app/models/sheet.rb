class Sheet < ActiveRecord::Base
  # serialize :line, Array
  # validates :line, presence: true
  has_many :notices, dependent: :destroy
  include Contact
  validates :invoice_name, presence: true
  validates :phone, presence: true
  validates :vat, presence: true
  has_one :address, class_name: 'Address',
                    dependent: :destroy,
                    as: :addressable

  def prepare_for_form
    prepare_contact
  end

end
