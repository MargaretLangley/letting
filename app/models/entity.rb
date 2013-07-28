class Entity < ActiveRecord::Base
  belongs_to :entitieable, polymorphic: true
  validates :entitieable_id, presence: true
  validates :name, presence: true
end
