class Entity < ActiveRecord::Base
  belongs_to :entitieable, polymorphic: true
  validates :name, presence: true
end
