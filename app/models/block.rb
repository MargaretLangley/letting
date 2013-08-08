class Block < ActiveRecord::Base
  validates :name, presence: true
end
