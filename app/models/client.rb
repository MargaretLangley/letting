class Client < ActiveRecord::Base
  has_many :entities, dependent: :destroy, as: :entitieable
  accepts_nested_attributes_for :entities, allow_destroy: true
  has_one :address, class_name: 'Address', dependent: :destroy, as: :addressable
  accepts_nested_attributes_for :address, allow_destroy: true

  validates :human_client_id, numericality: true
  validates :human_client_id, uniqueness: true
  validates :entities, presence: true
end
