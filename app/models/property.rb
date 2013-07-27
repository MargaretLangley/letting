class Property < ActiveRecord::Base
  has_many :addresses, dependent: :destroy, as: :contact

  def location
    addresses.first
  end
end
