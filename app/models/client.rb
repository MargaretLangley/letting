class Client < ActiveRecord::Base
  has_many :entities, dependent: :destroy, as: :entitieable
  accepts_nested_attributes_for :entities, allow_destroy: true
  has_one :address, class_name: 'Address', dependent: :destroy, as: :addressable
  accepts_nested_attributes_for :address, allow_destroy: true
  before_validation :clear_up_after_form

  MAX_ENTITIES = 2

  validates :human_client_id, numericality: true
  validates :human_client_id, uniqueness: true
  validates :entities, presence: true

  def prepare_for_form
    self.build_address if self.address.nil?
    (self.entities.size...MAX_ENTITIES).each { self.entities.build }
    true
  end

  def clear_up_after_form
    self.entities.select(&:empty?).each {|entity| mark_entity_for_destruction entity }
  end

  private
    def mark_entity_for_destruction entity
      entity.mark_for_destruction
    end

end
