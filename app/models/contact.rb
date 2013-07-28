module Contact
  extend ActiveSupport::Concern
  included do
    has_many :entities, dependent: :destroy, as: :entitieable
    has_one :address, class_name: 'Address', dependent: :destroy, as: :addressable
    accepts_nested_attributes_for :address, allow_destroy: true
  end
end
