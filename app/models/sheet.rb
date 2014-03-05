class Sheet < ActiveRecord::Base
  # serialize :epithet, Array
  # serialize :klass, Array
  # validates :epithet, presence: true
  # validates :line, presence: true
  # validates :klass, presence: true
  include Contact
  validates :inv_name, presence: true
  has_one :address, class_name: 'Address',
                    dependent: :destroy,
                    as: :addressable

  def prepare_for_form
    prepare_contact
  end

end
