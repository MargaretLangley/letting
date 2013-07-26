class Property < ActiveRecord::Base
  has_many :addresses, dependent: :destroy, as: :contact
end
