class Block < ActiveRecord::Base
  has_many :properties
  validates :client_id, :name, presence: true
end
