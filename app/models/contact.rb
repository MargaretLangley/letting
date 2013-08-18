module Contact
  extend ActiveSupport::Concern
  include Entities
  included do
    accepts_nested_attributes_for :entities, allow_destroy: true, reject_if: :all_blank
    has_one :address, class_name: 'Address', dependent: :destroy, as: :addressable
    accepts_nested_attributes_for :address, allow_destroy: true
  end

private
  def prepare_contact
    prepare_address if self.address.nil?
    entities.prepare
  end

    def prepare_address
      self.build_address
    end
end
