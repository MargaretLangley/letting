class BillingProfile < ActiveRecord::Base
  belongs_to :property
  has_many :entities, dependent: :destroy, as: :entitieable
  accepts_nested_attributes_for :entities, allow_destroy: true
  has_one :address, class_name: 'Address', dependent: :destroy, as: :addressable
  accepts_nested_attributes_for :address, allow_destroy: true
  validates :entities, :presence => true, if: :use_profile?
  before_validation :clear_up_after_form


  def prepare_for_form
    self.build_address if self.address.nil?
    (self.entities.count..1).each { self.entities.build }
    true
  end

  def clear_up_after_form
    if use_profile?
      self.entities.select(&:empty?).each {|entity| mark_entity_for_destruction entity }
    else
      self.address.mark_for_destruction unless self.address.nil?
      self.entities.each {|entity| mark_entity_for_destruction entity }
    end
  end

private
  def mark_entity_for_destruction entity
    entity.mark_for_destruction
  end

end
