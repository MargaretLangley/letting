module Contact
  extend ActiveSupport::Concern

  included do
    has_many :entities, dependent: :destroy, as: :entitieable
    accepts_nested_attributes_for :entities, allow_destroy: true, reject_if: :all_blank
    has_one :address, class_name: 'Address', dependent: :destroy, as: :addressable
    accepts_nested_attributes_for :address, allow_destroy: true
  end

  MAX_ENTITIES = 2

private

  def prepare_contact
    prepare_address if self.address.nil?
    prepare_entities
  end

    def prepare_address
      self.build_address
    end

    def prepare_entities
      (self.entities.size...MAX_ENTITIES).each { self.entities.build }
    end

  def entities_for_destruction matcher
    self.entities.select(&matcher).each {|entity| mark_entity_for_destruction entity }
  end

    def mark_entity_for_destruction entity
      entity.mark_for_destruction
    end

end
